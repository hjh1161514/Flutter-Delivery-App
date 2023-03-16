import 'package:json_annotation/json_annotation.dart';

import '../../restaurant/model/restaurant_model.dart';

part 'cursor_pagination_model.g.dart';

@JsonSerializable(
  genericArgumentFactories: true, // 제너릭을 쓰기 위해 필요
)
class CursorPagination<T>{
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });
  
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

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json)
  => _$CursorPaginationMetaFromJson(json);
}