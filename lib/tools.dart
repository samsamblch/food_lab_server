import 'dart:convert';
import 'dart:io';

class Tools {
  static String? parseArgs({required List<String> args, required String key}) {
    String? value;

    for (var arg in args) {
      print(arg);
      if (arg.contains(key)) {
        value = arg.replaceAll('$key ', '');
      }
    }

    return value;
  }

  static Future<Map<String, dynamic>> readJsonFromAsset(String filePath) async {
    var input = await File(filePath).readAsString();
    var json = jsonDecode(input);
    return json;
  }
}
