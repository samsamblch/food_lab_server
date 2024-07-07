import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class TemplateService {
  TemplateService({
    required this.basePath,
  });

  final String basePath;

  void setup(Router router) {
    router.get(routePath(), _rootHandler);

    router.get(routePath(subpath: '/user'), _userHandler);
  }

  String routePath({String subpath = ''}) => '$basePath$subpath';

  Response _rootHandler(Request req) {
    final queryParams = req.url.queryParameters;
    
    return Response.ok('Template Service in work!\n');
  }

  Response _userHandler(Request request) {
    return Response.internalServerError(body: 'Method no inplements');
  }
}
