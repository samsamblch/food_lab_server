import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class Server {
// Configure routes.
  late final _router = Router()
    ..get('/', _rootHandler)
    ..get('/echo/<message>', _echoHandler);

  Response _rootHandler(Request req) {
    return Response.ok('Hello, World!\n');
  }

  Response _echoHandler(Request request) {
    final message = request.params['message'];
    return Response.ok('$message\n');
  }

  Future<void> startServer({
    String? envPort,
  }) async {
    // Use any available host or container IP (usually `0.0.0.0`).
    final ip = InternetAddress.anyIPv4;

    // Configure a pipeline that logs requests.
    final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router.call);

    // For running in containers, we respect the PORT environment variable.
    final port = int.parse(envPort ?? '8080');
    final server = await serve(handler, ip, port);
    print('Server listening on port ${server.port}');
  }
}
