import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class OrderstatusService {
  OrderstatusService({
    required this.basePath,
  });

  final String basePath;

  void setup(Router router) {
    router.get(routePath(), _rootHandler);
  }

  String routePath({String subpath = ''}) => '$basePath$subpath';

  Response _rootHandler(Request req) {
    return Response.ok('Template Service in work!\n');
  }
}
