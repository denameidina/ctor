import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ctor/command/jira_command/jira_command.dart';
import 'package:ctor/core/core.dart';

const String version = '0.0.5';

void main(List<String> arguments) {
  final runner = CommandRunner(
      'ctor', 'CtoR is change your commit messages to release note')
    ..addCommand(JiraCommand());

  runner.argParser.addFlag(
    'version',
    abbr: 'v',
    help: 'Reports the version of this tool.',
    negatable: false,
  );

  try {
    final results = runner.argParser.parse(arguments);
    if (results.wasParsed('version')) {
      print(version);
      exit(0);
    }
  } catch (e) {
    printerr(red(e.toString()));
  }

  runner.run(arguments).onError((error, stackTrace) {
    printerr(red(error.toString()));
    printerr(red(stackTrace.toString()));
    exit(1);
  });
}
