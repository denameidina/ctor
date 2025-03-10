import 'dart:io';

import 'package:ctor/core/core.dart';

abstract class StatusHelper {
  static void success([String? message]) {
    if (message != null) {
      print(message);
    }
    print(green('SUCCESS'));
  }

  static void warning(String message) {
    printerr(orange(message));
  }

  static void failed(String message, {bool isExit = true, int statusExit = 1}) {
    printerr(red(message));
    printerr(red('FAILED'));
    if (isExit) {
      exit(statusExit);
    }
  }

  static void generated(String path) {
    print('${green('generated')} $path');
  }

  static void refactor(String path) {
    print('${green('refactor')} $path');
  }
}
