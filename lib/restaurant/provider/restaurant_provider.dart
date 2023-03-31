
import 'dart:ui';

import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/model/pagination_params.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/provider/pagination_provider.dart';
import '../repository/restaurant_repository.dart';

// restaurantProvider 상태에 반응을 해서 상태 안에서 데이터 값을 불러옴
// 단순하게 restaurantModel 반환
// restaurantProvider를 watch하고 있어서 restaurantProvider서 상태가 변경되면 detailProvider도 재빌드
final restaurantDetailProvider = Provider.family<RestaurantModel?, String>((ref, id) { // 프로바이더를 생성할 때 id값을 넣어줌
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    // CursorPagination이 아니라는 것은 데이터가 없다는 뜻 => 그냥 return
    return null;
  }

  return state.data.firstWhere((element) => element.id == id); // id에 해당하는 restaurant를 반환
});

// provider 안에 넣기
// stateNotifier를 넣기 위해 StateNotifierProvider 사용
final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>(
      (ref) {
    final repository = ref.watch(restaurantRepositoryProvider);
    final notifier = RestaurantStateNotifier(repository: repository);

    return notifier;
  },
);

// <CursorPagination>? => 다음 페이지를 불러올 때 CursorPagination에 들어온 meta, hasMore을 가지고 더 있으면 요청을 추가할 수 있음
// <CursorPaginationBase>를 사용함으로써 자식인 class 모두 사용 가능해짐
class RestaurantStateNotifier
    extends PaginationProvider<RestaurantModel, RestaurantRepository> {
  // extends를 통해 super 클래스에 들어가니까 repository 필요 없음
  // final RestaurantRepository repository;

  RestaurantStateNotifier({
    required super.repository,
  });

  // 실제 pagination을 진행하고 상태 안에다 응답 받은 리스트로 된 레스토랑 값을 넣음
  // 위젯에서는 상태를 바라보고 있다가 상태가 변경되면 새로운 값을 렌더링
  Future<void> paginate({
    //pagination_params에서 count와 같은 값
    int fetchCount = 20,

    // 추가로 데이터 더 가져오기
    // true - 추가로 데이터 더 가져옴
    // false - 새로고침. 첫번째 데이터를 다시 가져와서 현재 상태를 덮어씌움 - 데이터를 유지하면서 새로고침
    bool fetchMore = false,

    // 강제로 다시 로딩하기
    // true - CursorPaginationLoading() - 화면에 데이터가 모두 지워지고 가운데에서 로딩 effect
    bool forceRefetch = false,
  }) async{
    try{
      // 5가지 가능성
      // State의 상태 -> CursorPaginationBase를 extends하는 class가 5개
      // [상태가]
      // 1) CursorPagination - 정상적으로 데이터가 있는 상태
      // 2) CursorPaginationLoading = 데이터가 로딩 중인 상태 (현재 캐시 없음) => forceRefetch = true
      // 3) CursorPaginationError - 에러가 있는 상태
      // 4) CursorPaginationRefetching - 첫번째 페이지부터 다시 데이터를 가져올 때
      // 5) CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청을 받았을 떄

      // =====
      //  바로 반환하는 상황
      // (1) hasMore = false (기존 상태에서 이미 다음 데이터가 없다는 값을 들고 있다면)
      // (2) 로딩 중 - fetchMore = true => 앱에서 맨 아래까지 스크롤하고 더 데이터를 가져오라고 하는 상황
      // 추가 데이터를 가져와야 하는 상황에서 paginate 함수가 다시 실행된다면
      // 갖고 있는 20개 데이터에서 다음 데이터가 들어오기 전에 똑같은 요청을 넣으면 똑같은 20개의 데이터를 가져옴

      // (1)
      // 로딩중일 때 fetchMore가 아닐 때는 실행. -> 기존 요청을 멈추고 새로운 데이터를 요청하는 거라고 생각 => 새로 고침의 의도가 있을 수 있음
      if(state is CursorPagination && !forceRefetch) { // pagination을 한 번 이상해서 이미 데이터가 있음
        // 아직 dart에서 state.을 바로 사용할 수 없어서 CursorPagination이라는 것을 한 번 더 명시
        final pState = state as CursorPagination;

        if (!pState.meta.hasMore) { // 더 데이터가 없으면
          return;
        }
      }

      // (2)
      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if(fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // =====
      // 아무런 값이 없으면 서버에서 오는 값(20)으로 지정
      // PaginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: fetchCount,
      );

      // fetchMore 상황
      // 데이터를 추가로 더 가져오는 상황
      if (fetchMore) {
        final pState = state as CursorPagination; // fetchMore을 실행할 수 있는 상황 = 화면에 데이터가 보여지는 상황

        // 데이터를 유지한 채로 class 이름만 변경
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      }
      // ===
      // 데이터를 처음부터 가져오는 상황 - params 변경 필요 없음
      else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한 채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination;

          // 데이터를 유지하다가 새로운 데이터가 오면 대체
          state = CursorPaginationRefetching(
            meta: pState.meta,
            data: pState.data,
          );
        }
        // 나머지 상황
        else {
          state = CursorPaginationLoading();
        }
      }

      // 로딩이 돌아가는 순간 요청을 넣어야 함
      // 가장 최근 데이터 (20)개
      final resp = await repository.paginate(
        paginationParams: paginationParams,
      );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        // 응답이 다 왔기 때문에 로딩 상태를 로딩이 끝난 상태로 변경
        state = resp.copyWith(
          // 기존 데이터에 새로운 데이터 추가
            data: [
              ...pState.data, // 기존
              ...resp.data, // 새로운
            ]
        );
      } else {
        // resp는 맨처음 데이터라서
        state = resp;
      }
    }catch(e) {
      state = CursorPaginationError(message: "데이터를 가져오지 못했습니다.");
    }
  }

  void getDetail({
    required String id,
  }) async {
   // 만약에 아직 데이터가 하나도 없는 상태라면 (CursorPagination이 아니라면)
   // 데이터를 가져오는 시도를 한다
   if (state is! CursorPagination) {
     await this.paginate();
   }

   // pagination을 했는데도 state가 CursorPagination이 아닐 떄 그냥 리턴
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;
    
    final resp = await repository.getRestaurantDetail(id: id);

    // [RestaurantModel(1), RestaurantModel(2), RestaurantModel(3)]
   // id: 2인 친구들 Detail 모델을 가져와라
   // getDetail(id:2);
   // [RestaurantModel(1), RestaurantDetailModel(2), RestaurantModel(3)]
   state = pState.copyWith(
      // 특정 e의 id와 상세정보로 가져오려고 하는 id값이 같으면 element를 resp로 변경
      // => 요청을 한 데이터만 restaurantDetail로 변경
      data: pState.data.map<RestaurantModel>((e) => e.id == id ? resp : e).toList(),
    );
  }
}