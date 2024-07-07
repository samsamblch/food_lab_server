// pubspec_generator.dart

import 'dart:io';

import 'tools.dart';

void generate(Map<String, dynamic> spec) {
  final outputDir = toProjectNameCase(spec['info']['title']);
  createDirIfNotExists(outputDir);

  generatePubspec(spec, outputDir);

  print('pubspec.yaml generated in $outputDir/.');
}

void generatePubspec(Map<String, dynamic> spec, String outputDir) {
  if (spec['info'] == null || spec['info']['title'] == null || spec['info']['version'] == null) {
    print('No title or version found in the OpenAPI specification.');
    return;
  }

  final title = toProjectNameCase(spec['info']['title']);
  final version = spec['info']['version'];

  final buffer = StringBuffer();
  buffer.writeln('name: $title');
  buffer.writeln('description: ${spec['info']['description'] ?? '$title API'}');
  buffer.writeln('version: $version');
  buffer.writeln('homepage: homepage');

  buffer.writeln();
  buffer.writeln('environment:');
  buffer.writeln('  sdk: ">=3.4.3 <4.0.0"');
  buffer.writeln();
  buffer.writeln('dependencies:');
  buffer.writeln('  shelf: ^1.4.0');
  buffer.writeln('  shelf_router: ^1.1.0');

  final filePath = '$outputDir/pubspec.yaml';
  final file = File(filePath);
  file.writeAsStringSync(buffer.toString());

  print('Generated pubspec.yaml for $title');
}
