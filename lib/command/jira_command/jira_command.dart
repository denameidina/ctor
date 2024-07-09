import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:ctor/command/jira_command/jira_response.dart';
import 'package:ctor/core/core.dart';
import 'package:ctor/helper/status_helper.dart';
import 'package:ctor/helper/yaml_helper.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

const String scheme = 'https';
const String host = 'saas-telkomcorpu.atlassian.net';

class JiraTicket {
  JiraTicket({
    this.code,
    required this.commitMessage,
    this.isDone = false,
  });

  final String? code;
  final String commitMessage;
  final bool isDone;
}

class ReleaseNote {
  ReleaseNote({
    this.jiraKey,
    required this.summary,
  });

  final String? jiraKey;
  final String summary;

  String link() => "$scheme://$host/browse/$jiraKey";

  String plain() => '$jiraKey: $summary';

  String markdown() => '[$jiraKey](${link()}): $summary';

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

    final regExp = RegExp(r'^(wip|Wip|WIP)?(.+)\((\w+-\d+)\):\s(.+)');

    final jiraTikets = commits.map((e) {
      final match = regExp.firstMatch(e);
      final isDone = match?.group(1) != null;
      final code = match?.group(3);
      final commitMessage = match?.group(4) ?? e.split(':').last.trim();

      return JiraTicket(
        code: code,
        commitMessage: commitMessage,
        isDone: isDone,
      );
    }).toList();

    final jqlJiraTiket =
        List<JiraTicket>.from(jiraTikets).map((e) => e.code ?? '').toSet();
    jqlJiraTiket.removeWhere((element) => element.isEmpty);

    try {
      final response = await fetchJiraSearch(
        keys: jqlJiraTiket,
        authorization: getAuthorization(email ?? '', token ?? ''),
      );

      StringBuffer releaseNoteBuffer = StringBuffer();

      Map<ReleaseNote, List<ReleaseNote>> groupedByParent =
          groupByParent(response?.issues ?? []);

      groupedByParent.forEach((parentReleaseNote, childrenReleaseNote) {
        releaseNoteBuffer.writeln(parentReleaseNote.output(output));
        for (var releaseNote in childrenReleaseNote) {
          releaseNoteBuffer.writeln('  - ${releaseNote.output(output)}');
        }
      });

      print(releaseNoteBuffer.toString());
    } catch (e) {
      StatusHelper.failed(e.toString());
    }
  }

  Map<ReleaseNote, List<ReleaseNote>> groupByParent(List<IssuesJira> issues) {
    Map<ReleaseNote, List<ReleaseNote>> groupedIssues = {};

    for (var issue in issues) {
      final parentReleaseNote = ReleaseNote(
        jiraKey: issue.fields?.parent?.key,
        summary: issue.fields?.parent?.fields?.summary ?? '',
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

    return groupedIssues;
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
