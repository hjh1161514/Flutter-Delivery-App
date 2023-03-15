import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import '../model/restaurant_detail_model.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository { // repository 클래스는 무조건 abstract로 선언
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
  _RestaurantRepository;

  // http://$ip/restaurant/
  // @GET('/')
  // // pagination 관련
  // paginate();

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoiYWNjZXNzIiwiaWF0IjoxNjc4ODU4MDI4LCJleHAiOjE2Nzg4NTgzMjh9.WfnwqagxJR0B_ETw5J0sVDrI02INUeozKBJLdfqYaYE'
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}