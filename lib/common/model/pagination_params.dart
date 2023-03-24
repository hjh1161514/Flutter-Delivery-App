
import 'package:json_annotation/json_annotation.dart';

part 'pagination_params.g.dart';

// fromJson을 만들 수 있음
@JsonSerializable()
class PaginationParams {
  final String? after;
  final int? count;

  const PaginationParams({
    this.after,
    this.count,
  });

  // copywith?
  // count를 유지한 상태로 after를 바꾸거나, after를 유지한 상태로 count를 바꾸는 경우
  // => 특정 값만 바꾸고 싶은 경우
  PaginationParams copyWith({
    String? after,
    int? count,
}) {
    return PaginationParams(
      after: after ?? this.after,
      count: count ?? this.count,
    );
}

  // after, count 값을 응답으로 넣는 것이 아니라 직접 넣는 거라 fromJson이 필요없음
  factory PaginationParams.fromJson(Map<String, dynamic> json)
  => _$PaginationParamsFromJson(json);

  // 오히려 보낼 때 mapping을 해야 해서 toJson이 더 중요
  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}