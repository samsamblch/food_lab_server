import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class WelcomeService {
  void setup(Router router) {
    // router.get(route, handler);

    router.get('/', _rootHandler);
    router.get('/echo/<message>', _echoHandler);
  }

  Response _rootHandler(Request req) {
    return Response.ok('Hello, World!\n');
  }

  Response _echoHandler(Request request) {
    final message = request.params['message'];
    return Response.ok('$message\n');
  }
}
