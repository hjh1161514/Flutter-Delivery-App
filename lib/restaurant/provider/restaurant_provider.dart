
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/restaurant_repository.dart';

// provider 안에 넣기
// stateNotifier를 넣기 위해 StateNotifierProvider 사용
final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>(
   (ref) {
     final repository = ref.watch(restaurantRepositoryProvider);
     final notifier = RestaurantStateNotifier(repository: repository);

     return notifier;
   },
);

// <CursorPagination>? => 다음 페이지를 불러올 때 CursorPagination에 들어온 meta, hasMore을 가지고 더 있으면 요청을 추가할 수 있음
class RestaurantStateNotifier extends StateNotifier<CursorPagination> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({
    required this.repository,
  }): super(CursorPagination(meta: meta, data: data)) {
    // 클래스가 생성되면 pagination을 바로 요청 <- 가지고 와서 데이터를 기억하고 있으면 되기 때문
    // class가 인스턴스화 될 때 pagination을 실행
    /// RestaurantStateNotifier가 생성되는 순간 pagination 실행
    paginate();
  }

  // 실제 pagination을 진행하고 상태 안에다 응답 받은 리스트로 된 레스토랑 값을 넣음
  // 위젯에서는 상태를 바라보고 있다가 상태가 변경되면 새로운 값을 렌더링
  paginate() async{
    final resp = await repository.paginate();

    state = resp.data;
    // -> paginate를 실행해서 상태를 가져와서 state에 집어 넣음
    // home 화면에서 watch를 하고 있기 때문에 변경될 때마다 홈 화면이 렌더링
  }
}