// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:collection/collection.dart';
import 'package:ctor/command/jira_command/jira_response.dart';
import 'package:ctor/core/core.dart';
import 'package:ctor/helper/status_helper.dart';
import 'package:ctor/helper/yaml_helper.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

const String scheme = 'https';
const String host = 'saas-telkomcorpu.atlassian.net';

class DataCommit {
  DataCommit({
    this.type,
    this.jiraKey,
    required this.commitMessage,
    required this.fullCommit,
  });

  final String? type;
  final String? jiraKey;
  final String commitMessage;
  final String fullCommit;
}

class ReleaseNote {
  ReleaseNote({
    this.jiraKey,
    required this.summary,
  });

  final String? jiraKey;
  final String summary;

  String link() => "$scheme://$host/browse/$jiraKey";

  String plain() =>
      jiraKey == null ? summary.trim() : '$jiraKey: ${summary.trim()}';

  String markdown() => jiraKey == null
      ? summary.trim()
      : '[$jiraKey](${link()}): ${summary.trim()}';

  String output(String type) {
    switch (type) {
      case 'markdown':
        return markdown();
      default:
        return plain();
    }
  }

  @override
  bool operator ==(covariant ReleaseNote other) {
    if (identical(this, other)) return true;

    return other.jiraKey == jiraKey && other.summary == summary;
  }

  @override
  int get hashCode => jiraKey.hashCode ^ summary.hashCode;
}

class JiraCommand extends Command {
  JiraCommand() {
    argParser.addOption(
      'start',
      abbr: 's',
      help: 'Hash start commit',
      mandatory: true,
    );
    argParser.addOption(
      'end',
      abbr: 'e',
      help: 'Hash end commit',
      defaultsTo: 'HEAD',
    );
    argParser.addOption(
      'email',
      help: 'Email to identify your jira account',
    );
    argParser.addOption(
      'token',
      help: 'Token to identify yout jira account',
    );
    argParser.addOption(
      'ignore',
      help: 'Ignore commit message into release note separate with comma',
    );
    argParser.addFlag(
      'ignore-casesensitive',
      help: 'Ignore case sensitive',
      defaultsTo: false,
    );
    argParser.addOption(
      'output',
      abbr: 'o',
      help: 'Output type',
      allowed: ['plain', 'markdown'],
      defaultsTo: 'markdown',
    );
  }

  @override
  String get name => 'jira';

  @override
  String get description =>
      'Change commit messages to release note with implemented JIRA api';

  @override
  void run() async {
    final ctorYaml = YamlHelper.loadFileYaml(join(current, 'ctor.yaml'));

    final start = argResults?['start']?.toString();
    final end = argResults?['end']?.toString() ?? 'HEAD';
    final email =
        argResults?['email']?.toString() ?? ctorYaml['email_jira']?.toString();
    final token =
        argResults?['token']?.toString() ?? ctorYaml['token_jira']?.toString();
    final output = argResults?['output']?.toString() ?? 'markdown';
    final commitIgnores = argResults?['ignore']?.toString().split(',') ??
        ctorYaml['ignore']?.toString().split(',') ??
        [];
    final bool ignoreCasesensitive = argResults?['ignore-casesensitive'] ??
        ctorYaml['ignore_casesensitive'] ??
        false;

    if ((email?.isEmpty ?? true) || (token?.isEmpty ?? true)) {
      StatusHelper.failed(
        'Email or token is null or empty please check your ctor.yaml or your argument',
      );
    }

    StringBuffer rawCommits = StringBuffer();

    await 'git log --pretty=format:"%s" $start..$end'.start(
      progressErr: (line) => rawCommits.writeln(line),
      progressOut: (line) => rawCommits.writeln(line),
      showLog: false,
    );

    List<String> commits = rawCommits.toString().split('\n')
      ..removeWhere((element) => element.isEmpty);

    final regExpType = RegExp(
        r'(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)');
    final regExpJiraKey = RegExp(r'(\w+-\d+)');

    List<DataCommit> dataCommits = [];

    for (var commit in commits) {
      final allMatch = regExpJiraKey.allMatches(commit);
      final type = regExpType.firstMatch(commit)?.group(1);
      final commitMessage = commit.split(':').last.trim();

      if (allMatch.isNotEmpty) {
        for (var matchCode in allMatch) {
          final code = matchCode.group(1);

          dataCommits.add(DataCommit(
            type: type,
            jiraKey: code,
            commitMessage: commitMessage,
            fullCommit: commit,
          ));
        }
      } else {
        dataCommits.add(DataCommit(
          type: type,
          commitMessage: commitMessage,
          fullCommit: commit,
        ));
      }
    }

    // remove ignore
    if (commitIgnores.isNotEmpty) {
      dataCommits.removeWhere(
        (dataCommit) {
          final data = commitIgnores.firstWhereOrNull((ignore) {
            if (ignoreCasesensitive) {
              return dataCommit.fullCommit.contains(ignore);
            } else {
              return dataCommit.fullCommit
                  .toLowerCase()
                  .contains(ignore.toLowerCase());
            }
          });
          return data != null;
        },
      );
    }

    final jiraTickets = List<DataCommit>.from(
        dataCommits.where((element) => element.jiraKey?.isNotEmpty ?? false));

    final otherTickets = List<DataCommit>.from(
      dataCommits.where((ticket) => ticket.jiraKey?.isEmpty ?? true),
    );

    try {
      final response = await fetchJiraSearch(
        keys: jiraTickets.map((e) => e.jiraKey ?? '').toSet(),
        authorization: getAuthorization(email ?? '', token ?? ''),
      );

      StringBuffer releaseNoteBuffer = StringBuffer();

      final added = groupByParent(
          jiraTickets, otherTickets, response?.issues ?? [], RegExp(r'feat'));
      final changed = groupByParent(jiraTickets, added.$3, added.$2,
          RegExp(r'(refactor|style|perf|build)'));
      final fixed =
          groupByParent(jiraTickets, changed.$3, changed.$2, RegExp(r'fix'));
      final removed =
          groupByParent(jiraTickets, fixed.$3, fixed.$2, RegExp(r'revert'));
      final other = groupByParent(jiraTickets, removed.$3, removed.$2, null);

      if (added.$1.isNotEmpty) {
        releaseNoteBuffer.writeln('### Added');
        for (var element in added.$1) {
          // With Ticket
          element.forEach((parentReleaseNote, childrenReleaseNote) {
            releaseNoteBuffer.writeln('* ${parentReleaseNote.output(output)}');
            for (var releaseNote in childrenReleaseNote) {
              releaseNoteBuffer.writeln('  * ${releaseNote.output(output)}');
            }
          });
        }
        releaseNoteBuffer.writeln();
      }

      if (changed.$1.isNotEmpty) {
        releaseNoteBuffer.writeln('### Changed');
        for (var element in changed.$1) {
          // With Ticket
          element.forEach((parentReleaseNote, childrenReleaseNote) {
            releaseNoteBuffer.writeln('* ${parentReleaseNote.output(output)}');
            for (var releaseNote in childrenReleaseNote) {
              releaseNoteBuffer.writeln('  * ${releaseNote.output(output)}');
            }
          });
        }
        releaseNoteBuffer.writeln();
      }

      if (fixed.$1.isNotEmpty) {
        releaseNoteBuffer.writeln('### Fixed');
        for (var element in fixed.$1) {
          // With Ticket
          element.forEach((parentReleaseNote, childrenReleaseNote) {
            releaseNoteBuffer.writeln('* ${parentReleaseNote.output(output)}');
            for (var releaseNote in childrenReleaseNote) {
              releaseNoteBuffer.writeln('  * ${releaseNote.output(output)}');
            }
          });
        }
        releaseNoteBuffer.writeln();
      }

      if (removed.$1.isNotEmpty) {
        releaseNoteBuffer.writeln('### Removed');
        for (var element in removed.$1) {
          // With Ticket
          element.forEach((parentReleaseNote, childrenReleaseNote) {
            releaseNoteBuffer.writeln('* ${parentReleaseNote.output(output)}');
            for (var releaseNote in childrenReleaseNote) {
              releaseNoteBuffer.writeln('  * ${releaseNote.output(output)}');
            }
          });
        }
        releaseNoteBuffer.writeln();
      }

      if (other.$1.isNotEmpty) {
        releaseNoteBuffer.writeln('### Other');
        for (var element in other.$1) {
          // With Ticket
          element.forEach((parentReleaseNote, childrenReleaseNote) {
            releaseNoteBuffer.writeln('* ${parentReleaseNote.output(output)}');
            for (var releaseNote in childrenReleaseNote) {
              releaseNoteBuffer.writeln('  * ${releaseNote.output(output)}');
            }
          });
        }
      }

      print(releaseNoteBuffer.toString());
    } catch (e) {
      StatusHelper.failed(e.toString());
    }
  }

  (
    List<Map<ReleaseNote, List<ReleaseNote>>> result,
    List<IssuesJira> remainingIssues,
    List<DataCommit> remainingOtherTicket,
  ) groupByParent(
    List<DataCommit> jiraTickets,
    List<DataCommit> otherTicket,
    List<IssuesJira> issues,
    RegExp? regExp,
  ) {
    List<IssuesJira> remainingIssues = [];
    List<DataCommit> remainingOtherTicket = [];
    List<Map<ReleaseNote, List<ReleaseNote>>> listOfGroupedIssue = [];
    Map<ReleaseNote, List<ReleaseNote>> groupedIssues = {};

    // Jira
    for (var issue in issues) {
      final hasMatchJira = jiraTickets.firstWhereOrNull((element) =>
              element.jiraKey == issue.key &&
              (regExp?.hasMatch(element.type ?? '') ?? false)) !=
          null;

      if (regExp != null && !hasMatchJira) {
        remainingIssues.add(issue);
        continue;
      }

      final parentReleaseNote = ReleaseNote(
        jiraKey: issue.fields?.parent?.key,
        summary: issue.fields?.parent?.fields?.summary ?? 'Parentless',
      );

      final childReleaseNote = ReleaseNote(
        jiraKey: issue.key,
        summary: issue.fields?.summary ?? '',
      );

      if (groupedIssues.containsKey(parentReleaseNote)) {
        groupedIssues[parentReleaseNote]?.add(childReleaseNote);
      } else {
        groupedIssues[parentReleaseNote] = [childReleaseNote];
      }
    }

    final otherReleaseNote = ReleaseNote(summary: 'Ticketless Jira');
    for (var element in otherTicket) {
      final hasMatch = regExp?.hasMatch(element.type ?? '') ?? false;

      if (regExp != null && !hasMatch) {
        remainingOtherTicket.add(element);
        continue;
      }

      final childReleaseNote = ReleaseNote(summary: element.fullCommit);

      if (groupedIssues.containsKey(otherReleaseNote)) {
        groupedIssues[otherReleaseNote]?.add(childReleaseNote);
      } else {
        groupedIssues[otherReleaseNote] = [childReleaseNote];
      }
    }

    if (groupedIssues.isNotEmpty) listOfGroupedIssue.add(groupedIssues);

    return (listOfGroupedIssue, remainingIssues, remainingOtherTicket);
  }

  String getAuthorization(String email, String token) =>
      'Basic ${base64.encode(utf8.encode('$email:$token'))}';

  Future<JiraResponse?> fetchJiraSearch({
    required Set<String> keys,
    required String authorization,
  }) async {
    final response = await http.get(
      Uri(
        scheme: scheme,
        host: host,
        path: 'rest/api/2/search',
        queryParameters: {
          'fields': 'summary,parent',
          'jql': 'key in (${keys.join(',')})',
          'maxResults': '999',
        },
      ),
      headers: {
        "Accept": "application/json",
        "Authorization": authorization,
      },
    );

    return JiraResponse.fromJson(response.body);
  }
}
