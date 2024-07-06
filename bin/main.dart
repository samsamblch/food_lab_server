import 'package:lab_server/server.dart';
import 'package:lab_server/tools.dart';

void main(List<String> args) async {
  print(args);

  final server = Server();
  server.startServer(
    envPort: Tools.parseArgs(args: args, key: '--web-port'),
  );
}
