import '../model/cursor_pagination_model.dart';
import '../model/pagination_params.dart';

// dart에서 interface 키워드는 따로 존재하지 않음
// I로 나타냄
abstract class IBasePaginationRepository<T> {
  Future<CursorPagination<T>> paginate({
    // repository에서 query 추가 방법?
    // @Queries를 통해 query parameter로 변경
    // class가 자동으로 query로 변경됨
    PaginationParams? paginationParams = const PaginationParams(),
  });
}