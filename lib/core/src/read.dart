import 'dart:io';

import 'package:ctor/helper/status_helper.dart';

import 'is.dart';
import 'truepath.dart';

List<String> read(String path) {
  if (!exists(path)) {
    StatusHelper.failed('The file at ${truepath(path)} does not exists');
  }

  return File(path).readAsLinesSync();
}
