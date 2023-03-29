import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/model/model_with_id.dart';
import 'package:flutter_delivery_app/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/pagination_params.dart';

// dart 언어에서는 제너릭에 implements를 사용할 수 없음
// -> extends 사용
class PaginationProvider<
  T extends IModelWithId, // pagination에서 가져오는 값들의 실제 데이터 타입
  U extends IBasePaginationRepository<T>> extends StateNotifier<CursorPaginationBase> {
  // repository를 넘겨받기 위해
  // RestaurantRepository와 RestaurantRatingRepository가 따로 존재
  // -> 이를 하나로 묶기 위해 IBasePaginationRepository 생성
  final U repository;

  PaginationProvider({
    required this.repository
  }) :
        super(CursorPaginationLoading());

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
  }) async {
    try {
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
      if (state is CursorPagination &&
          !forceRefetch) { // pagination을 한 번 이상해서 이미 데이터가 있음
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

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
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
        final pState = state as CursorPagination<T>; // fetchMore을 실행할 수 있는 상황 = 화면에 데이터가 보여지는 상황

        // 데이터를 유지한 채로 class 이름만 변경
        // <>이 없다 -> dynamic으로 취급 -> dynamic을 줄이는 것이 좋음
        state = CursorPaginationFetchingMore(
          meta: pState.meta,
          data: pState.data,
        );

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id, // CursorPagination<T>이기 때문에 id가 무조건 존재
        );
      }
      // ===
      // 데이터를 처음부터 가져오는 상황 - params 변경 필요 없음
      else {
        // 만약에 데이터가 있는 상황이라면
        // 기존 데이터를 보존한 채로 Fetch (API 요청)를 진행
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;

          // 데이터를 유지하다가 새로운 데이터가 오면 대체
          state = CursorPaginationRefetching<T>(
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
        final pState = state as CursorPaginationFetchingMore<T>;

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
    } catch (e) {
      state = CursorPaginationError(message: "데이터를 가져오지 못했습니다.");
    }
  }
}