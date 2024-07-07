// service_generator.dart

import 'dart:io';

import 'tools.dart';

void generate(Map<String, dynamic> spec) {
  if (spec['servers'] == null || spec['paths'] == null) {
    print('No servers or paths found in the OpenAPI specification.');
    return;
  }

  final outputDir = toProjectNameCase(spec['info']['title'] + '/lib');
  createDirIfNotExists(outputDir);

  _generateService(spec['paths'], outputDir);

  print('Services generated in $outputDir/service.');
}

// Функция для генерации методов
void _generateService(Map<String, dynamic> paths, String outputDir) {
  final serviceDir = '$outputDir/service';
  createDirIfNotExists(serviceDir);

  paths.forEach((path, details) {
    final className = toClassName(path);
    final buffer = StringBuffer();

//     import 'package:shelf/shelf.dart';
// import 'package:shelf_router/shelf_router.dart';

// class TemplateService {
//   TemplateService({
//     required this.basePath,
//   });

    buffer.writeln('import \'package:shelf/shelf.dart\';');
    buffer.writeln('import \'package:shelf_router/shelf_router.dart\';');

    buffer.writeln('\nclass $className {');

    buffer.writeln('  $className({');
    buffer.writeln('    required this.basePath,');
    buffer.writeln('  });');

    buffer.writeln('\n  final String basePath;');
    buffer.writeln();
    buffer.writeln('  void setup(Router router) {');
    buffer.writeln('    router.get(routePath(), _rootHandler);');
    buffer.writeln('  }');

    buffer.writeln('\n  String routePath({String subpath = \'\'}) => \'\$basePath\$subpath\';');

    buffer.writeln('\n  Response _rootHandler(Request req) {');
    buffer.writeln('    return Response.ok(\'Template Service in work!\\n\');');
    buffer.writeln('  }');

    // details.forEach((method, operation) {
    //   final methodName = toMethodName(method, path);
    //   final returnType = determineReturnType(operation);
    //   final parameters = determineParameters(operation);

    //   buffer.writeln('  Future<$returnType> $methodName($parameters) async {');
    //   buffer.writeln('    // TODO: Implement $methodName');
    //   buffer.writeln('  }');
    //   buffer.writeln();
    // });

    buffer.writeln('}');

    final filePath = '$serviceDir/${toSnakeCase(className)}.dart';
    final file = File(filePath);
    file.writeAsStringSync(buffer.toString());

    print('Created file for service: $className');
  });
}

String toClassName(String path) {
  return '${path.split('/').map((part) => part.isNotEmpty ? part[0].toUpperCase() + part.substring(1) : '').join('')}Service';
}

String toMethodName(String method, String path) {
  final parts = path.split('/');
  final name = parts.isNotEmpty ? parts.last : '';
  return method.toLowerCase() + name[0].toUpperCase() + name.substring(1);
}

String determineReturnType(Map<String, dynamic> operation) {
  if (operation.containsKey('responses')) {
    final responses = operation['responses'] as Map<String, dynamic>;
    if (responses.containsKey('200') && responses['200'].containsKey('content')) {
      final content = responses['200']['content'] as Map<String, dynamic>;
      if (content.containsKey('application/json')) {
        final schema = content['application/json']['schema'];
        if (schema.containsKey('\$ref')) {
          final ref = schema['\$ref'] as String;
          final refName = ref.split('/').last;
          return refName[0].toUpperCase() + refName.substring(1);
        }
      }
    }
  }
  return 'void';
}

String determineParameters(Map<String, dynamic> operation) {
  if (operation.containsKey('parameters')) {
    final parameters = operation['parameters'] as List<dynamic>;
    return parameters.map((param) {
      final name = param['name'];
      final type = determineType(param['schema']);
      return '$type $name';
    }).join(', ');
  }
  return '';
}
