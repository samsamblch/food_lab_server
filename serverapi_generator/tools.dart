// tools.dart

import 'dart:io';

// // Функция для преобразования строки в snake_case
// Моя работает
// String toSnakeCase(String input) {
//   return input
//       .replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match[0]!.toLowerCase()}')
//       .replaceAll(RegExp(r'[\s_]+'), '_')
//       .replaceAll(RegExp(r'^[\s_]+|[\s_]+$'), '')
//       .toLowerCase();
// }

// Функция для преобразования строки в snake_case
String toSnakeCase(String input) {
  return input
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]}_${m[2]}')
      .replaceAll(RegExp(r'[\s_]+'), '_')
      .replaceAll(RegExp(r'^[\s_]+|[\s_]+$'), '')
      .toLowerCase();
}

// Функция для преобразования строки в формат имени проекта
String toProjectNameCase(String input) {
  return input.toLowerCase().replaceAll(' ', '_');
}

// Функция для создания папки, если она не существует
void createDirIfNotExists(String path) {
  final directory = Directory(path);
  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }
}


// Определение типа данных
String determineType(Map<String, dynamic> propDetails) {
  if (propDetails.containsKey('\$ref')) {
    final ref = propDetails['\$ref'] as String;
    final refName = ref.split('/').last;
    return refName[0].toUpperCase() + refName.substring(1);
  } else if (propDetails.containsKey('allOf')) {
    final String ref = propDetails['allOf']['\$ref'];
    final refName = ref.replaceAll('"', '').split('/').last;
    return refName[0].toUpperCase() + refName.substring(1);
  }

  final type = propDetails['type'];
  if (type == 'string') {
    return 'String';
  } else if (type == 'integer') {
    return 'int';
  } else if (type == 'number') {
    return 'double';
  } else if (type == 'boolean') {
    return 'bool';
  } else if (type == 'array') {
    final items = propDetails['items'] as Map<String, dynamic>?;
    final itemType = items != null ? determineType(items) : 'dynamic';
    return 'List<$itemType>';
  } else if (type == 'object' && propDetails.containsKey('properties')) {
    return 'Map<String, dynamic>';
  }
  return 'dynamic';
}
