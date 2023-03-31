import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/provider/pagination_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../rating/model/rating_model.dart';
import '../repository/restaurant_rating_repository.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
  RestaurantRatingStateNotifier,
  CursorPaginationBase, // 상태 타입
  String
>((ref, id) {
  // id값을 기반으로 원하는 레스토랑의 평점을 따로 받아올 수 있음
  final repo = ref.watch(restaurantRatingRepositoryProvider(id));

  return RestaurantRatingStateNotifier(repository: repo);
});

class RestaurantRatingStateNotifier extends PaginationProvider<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingStateNotifier({
    required super.repository,
  });
}