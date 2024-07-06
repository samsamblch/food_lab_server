class Tools {
  static String? parseArgs({required List<String> args, required String key}) {
    String? value;

    for (var arg in args) {
      print (arg);
      if (arg.contains(key)) {
        value = arg.replaceAll('$key ', '');
      }
    }

    return value;
  }
}
