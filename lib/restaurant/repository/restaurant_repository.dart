import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/common/dio/dio.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/model/pagination_params.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';
import '../../common/const/data.dart';
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>(
    (ref) {
      // dio는 dioProvider에 저장
      // watch? (가능성이 적지만) 만약 dioProvider 안에서 값이 변경된다면 restaurantRepositoryProvider를 다시 build하기 위해서
      final dio = ref.watch(dioProvider);
      
      final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

      return repository;
    }
);

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
  // 첫페이지는 after,count가 없어도 괜찮도록 서버 설계
  // 그러나 특정 커서의 다음 값들을 가져오려면 cursor값 필수
  // -> null 가능
  Future<CursorPagination<RestaurantModel>> paginate({
    // @Queries를 통해 query parameter로 변경
    // class가 자동으로 query로 변경됨
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });

  // http://$ip/restaurant/:id
  @GET('/{id}')
  @Headers({
    'accessToken': 'true', // accessToken을 dio.dart에서 붙여서 요청을 보냄
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}