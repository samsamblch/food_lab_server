// generator.dart

import 'dart:io';

import 'dto_generator.dart' as dto_generator;
import 'service_generator.dart' as service_generator;
import 'yaml_parser.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart generator.dart <path_to_openapi.yaml>');
    return;
  }

  final inputFile = args[0];

  final yamlContent = File(inputFile).readAsStringSync();
  final spec = loadYaml(yamlContent);

  print('Parsed OpenAPI spec:');

  dto_generator.generate(spec);
  service_generator.generate(spec);
}
