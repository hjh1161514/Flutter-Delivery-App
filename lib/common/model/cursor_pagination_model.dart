import 'package:json_annotation/json_annotation.dart';

import '../../restaurant/model/restaurant_model.dart';

part 'cursor_pagination_model.g.dart';

// class로 상태를 구분하기 위해서는 base class를 생성
// class 안에 값의 여부는 중요하지 않음. 상태 구분만 가능하면 됨
// -> 부모 클래스로 존재한다. 의미가 끝
abstract class CursorPaginationBase {}

// 에러가 났을 때 상태
class CursorPaginationError extends CursorPaginationBase{
  final String message;

  CursorPaginationError({
    required this.message,
  });
}

// 로딩 상태
// 데이터 정보를 속성에 넣지 않았기 떄문에 데이터가 사라짐 -> CursorPaginationFetchingMore 대신 사용할 수 없음
class CursorPaginationLoading extends CursorPaginationBase{}

@JsonSerializable(
  genericArgumentFactories: true, // 제너릭을 쓰기 위해 필요
)

/// 빈 class를 extends 이유? C
/// CursorPagination가 CursorPaginationBase의 타입인지 확인할 수 있다는 것이 중요
/// => CursorPagination는 CursorPaginationBase와 호환이 됨
// 실제로 값이 잘 받아와 졌을 때 상태
class CursorPagination<T> extends CursorPaginationBase{
  // 처음 로딩 시에는 meta, data를 가지고 있지 않기 떄문에 ? 추가
  // 그러나 서버 로직 상 에러가 생기지 null은 절대 불가능
  // => 따라서 상태를 class로 나눔
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });

  CursorPagination copyWith({
    CursorPaginationMeta? meta,
    List<T>? data,
  }) {
    return CursorPagination<T>(
        meta: meta ?? this.meta,
        data: data ?? this.data,
    );
  }
  
  factory CursorPagination.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) // .g파일을 생성할 떄 T를 알 수 없으므로 json으로부터 instance하는 방법을 정의하기 위해 추가
  => _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta{
  final int count;
  final bool hasMore;

  CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  CursorPaginationMeta copyWith({
    int? count,
    bool? hasMore,
  }) {
    return CursorPaginationMeta(
        count: count ?? this.count,
        hasMore: hasMore ?? this.hasMore,
    );
  }

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json)
  => _$CursorPaginationMetaFromJson(json);
}

// 새로고침할 때 다시 처음부터 불러오기. ex) 리스트에서 아래로 당기면 새로 로딩이 되는 것
// meta, data가 존재할 때 사용하기 때문에 CursorPagination extends
// CursorPaginationBase까지 extends
class CursorPaginationRefetching<T> extends CursorPagination<T>{
  CursorPaginationRefetching({
    required super.meta,
    required super.data,
  });
}

// 리스트의 맨 아래로 내려서 추가 데이터를 요청하는 중
class CursorPaginationFetchingMore<T> extends CursorPagination<T>{
  CursorPaginationFetchingMore({
    required super.meta,
    required super.data,
  });
}