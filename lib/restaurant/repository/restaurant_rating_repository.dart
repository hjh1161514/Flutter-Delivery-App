import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_delivery_app/rating/model/rating_model.dart';
import 'package:retrofit/http.dart';

import '../../common/model/cursor_pagination_model.dart';
import '../../common/model/pagination_params.dart';

part 'restaurant_rating_repository.g.dart';

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