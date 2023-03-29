import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/common/dio/dio.dart';
import 'package:flutter_delivery_app/rating/model/rating_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';
import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/pagination_params.dart';

part 'restaurant_rating_repository.g.dart';

// 어떤 레스토랑에서 지정하는지 알아야 하기 때문에 family로 지정
final restaurantRatingRepositoryProvider = Provider.family<RestaurantRatingRepository, String> ((ref, id) {
  final dio = ref.watch(dioProvider);
  
  return RestaurantRatingRepository(dio, baseUrl: 'http://$ip/restaurant/$id/rating');
});

@RestApi()
abstract class RestaurantRatingRepository{
  factory RestaurantRatingRepository(Dio dio, {String baseUrl}) =
      _RestaurantRatingRepository;

  @GET('/')
  @Headers({ // hide Headers 필요
    'accessToken': 'true',
  })
  Future<CursorPagination<RatingModel>> paginate({
    @Queries() PaginationParams? paginationParams = const PaginationParams(),
  });
}