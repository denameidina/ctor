import 'dart:io';

import 'package:ctor/core/core.dart';
import 'package:yaml/yaml.dart';

abstract class YamlHelper {
  static Map<dynamic, dynamic> loadFileYaml(String path) {
    try {
      final File file = File(path);
      final String yamlString = file.readAsStringSync();
      return loadYaml(yamlString);
    } catch (e) {
      printerr(e.toString());
      return {};
    }
  }
}
