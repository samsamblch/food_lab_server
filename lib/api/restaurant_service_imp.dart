import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:delivery_food_api/service/restaurant_service.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/src/router.dart';

import '../tools.dart';

class RestaurantServiceImp extends RestaurantService {
  RestaurantServiceImp({required super.basePath});

  @override
  void setup(Router router) {
    super.setup(router);
    print(routePath(subpath: '/restourant'));

    router.get(routePath(subpath: '/restourant'), _restourantHandler);
  }

  Future<Response> _restourantHandler(Request req) async {
    final json = await Tools.readJsonFromAsset('assets/jsons/delivery_food/restourant.json');

    await Future.delayed(Duration(seconds: 3));

    return Response.ok(
      jsonEncode(json),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );
  }
}
