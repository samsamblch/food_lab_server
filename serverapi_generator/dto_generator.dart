// dto_generator.dart

import 'dart:io';

import 'tools.dart';

void generate(Map<String, dynamic> spec) {
  if (spec['components'] == null || spec['components']['schemas'] == null) {
    print('No components.schemas found in the OpenAPI specification.');
    return;
  }

  final outputDir = toProjectNameCase(spec['info']['title']);
  createDirIfNotExists(outputDir);

  _generateDto(spec['components'], outputDir);

  print('DTOs generated in $outputDir/dto.');
}

// Функция для генерации DTO
void _generateDto(Map<String, dynamic> components, String outputDir) {
  final dtos = components['schemas'] as Map<String, dynamic>? ?? {};
  final dtoDir = '$outputDir/dto';
  createDirIfNotExists(dtoDir);

  dtos.forEach((name, schema) {
    print('Creating file for model: $name');

    final requiredFields = schema['required'] as List<String>? ?? [];
    final properties = schema['properties'] as Map<String, dynamic>? ?? {};
    final className = name[0].toUpperCase() + name.substring(1);

    final buffer = StringBuffer();

    // Генерация импортов класса
    Set<String> imports = dtos.keys.where((e) {
      bool exist = false;
      properties.forEach((propName, propDetails) {
        final type = determineType(propDetails);
        if (type.toLowerCase().contains(e.toLowerCase())) {
          exist = true;
        }
      });
      return exist;
    }).toSet();

    if (imports.isNotEmpty) {
      for (var import in imports) {
        buffer.writeln('import \'${toSnakeCase(import)}.dart\';');
      }
      buffer.writeln();
    }

    // Генерация полей класса
    buffer.writeln('class $className {');
    properties.forEach((propName, propDetails) {
      final isRequired = requiredFields.contains(propName);
      final type = determineType(propDetails);
      buffer.writeln('  final $type${!isRequired ? '?' : ''} $propName;');
    });

    // Конструктор класса
    buffer.writeln('\n  $className({');
    properties.forEach((propName, propDetails) {
      final isRequired = requiredFields.contains(propName);
      buffer.writeln('    ${isRequired ? 'required ' : ''}this.$propName,');
    });
    buffer.writeln('  });');

    // Фабричный метод fromJson
    buffer.writeln('\n  factory $className.fromJson(Map<String, dynamic> json) => $className(');
    properties.forEach((propName, propDetails) {
      buffer.writeln('    $propName: json[\'$propName\'],');
    });
    buffer.writeln('  );');

    // Метод toJson
    buffer.writeln('\n  Map<String, dynamic> toJson() => {');
    properties.forEach((propName, propDetails) {
      buffer.writeln('    \'$propName\': $propName,');
    });
    buffer.writeln('  };');
    buffer.writeln('}');

    final filePath = '$dtoDir/${toSnakeCase(name)}.dart';
    final file = File(filePath);
    file.writeAsStringSync(buffer.toString());
  });
}
