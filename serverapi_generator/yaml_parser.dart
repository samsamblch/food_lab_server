// yaml_parser.dart

Map<String, dynamic> loadYaml(String yaml) {
  final Map<String, dynamic> result = {};

  final dict = parseString(yaml);
  // print('dict keys: ${dict.keys.toString()}');
  for (var key in dict.keys) {
    final string = dict[key];

    if (key == 'required:' && string != null) {
      final newKey = key.replaceAll(':', '');
      final newValue = string.replaceAll('- ', '').split('\n').where((e) => e.isNotEmpty).toList();
      result[newKey] = newValue;
      continue;
    }

    Map<String, dynamic>? map;
    if (string != null) {
      map = loadYaml(string);
    }

    if (map != null && map.isNotEmpty) {
      final fixedKey = key.replaceAll(':', '').replaceAll('- ', '');

      result[fixedKey] = map;
    } else {
      // print('HELLOO 2');
      // print('key: >>$key<<');
      final parsedKey = key.split(': ');

      // if (key('required')) {
      //     result['required'] = map.keys.map((e) => e.replaceAll('- ', '')).toList();

      // }
      result[parsedKey.first.replaceAll('- ', '')] = parsedKey.last;
    }
  }

  return result; //result.keys.isNotEmpty ? result : null;
}

Map<String, String> parseString(String str) {
  Map<String, String> dict = {};

  String key = '';
  String value = '';

  final lines = str.split('\n');
  for (var line in lines) {
    if (line.trim().isEmpty || line.trim().startsWith('#')) continue;

    final space = line.substring(0, 2);

    if (space != '  ') {
      if (key.isEmpty) {
        key = line;
        value = '';
        continue;
      }

      // сохраняем старое записываем новое
      dict[key] = value;
      key = line;
      value = '';
    } else {
      // значит сохраняем в общую строку
      value += '${line.substring(2)}\n';
    }
  }

  if (key.isNotEmpty) {
    dict[key] = value;
  }

  return dict;
}

Map<String, dynamic> loadYamlOld(String yamlContent) {
  final lines = yamlContent.split('\n');
  final Map<String, dynamic> result = {};
  final List<Map<String, dynamic>> stack = [result];
  final List<int> indents = [-1];

  for (var line in lines) {
    if (line.trim().isEmpty || line.trim().startsWith('#')) continue;

    final indent = line.length - line.trimLeft().length;
    final trimmedLine = line.trim();

    while (indents.last >= indent) {
      stack.removeLast();
      indents.removeLast();
    }

    final currentMap = stack.last;

    if (trimmedLine.contains(':')) {
      final parts = trimmedLine.split(':');
      final key = parts[0].trim();
      var value = parts.length > 1 ? parts[1].trim() : null;

      if (value == null || value.isEmpty) {
        final newMap = <String, dynamic>{};
        currentMap[key] = newMap;
        stack.add(newMap);
        indents.add(indent);
      } else {
        if (value.startsWith('- ')) {
          value = value.substring(2).trim();
          if (currentMap[key] is! List) {
            currentMap[key] = [];
          }
          (currentMap[key] as List).add(value);
        } else {
          currentMap[key] = value;
        }
      }
    } else if (currentMap.isNotEmpty) {
      if (currentMap[currentMap.keys.last] is List) {
        (currentMap[currentMap.keys.last] as List).add(trimmedLine);
      }
    }
  }

  return result;
}
