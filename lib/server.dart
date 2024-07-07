import 'dart:io';

import 'package:lab_server/api/restaurant_service_imp.dart';
import 'package:lab_server/welcome_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

class Server {
// Configure routes.
  late final _router = Router();

  final welcomeService = WelcomeService();
  final restaurantService = RestaurantServiceImp(basePath: '/api/delivery');

  Future<void> startServer({
    String? envPort,
  }) async {
    welcomeService.setup(_router);
    restaurantService.setup(_router);

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
