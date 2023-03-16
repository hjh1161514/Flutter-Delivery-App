import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:retrofit/retrofit.dart';
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository { // repository 클래스는 무조건 abstract로 선언
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
  _RestaurantRepository;

  // http://$ip/restaurant/
  @GET('/')
  @Headers({
    'accessToken': 'true',
  })
  // pagination 관련
  Future<CursorPagination<RestaurantModel>> paginate();

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken': 'true', // accessToken을 dio.dart에서 붙여서 요청을 보냄
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}