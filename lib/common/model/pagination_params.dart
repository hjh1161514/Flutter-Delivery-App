
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

  // after, count 값을 응답으로 넣는 것이 아니라 직접 넣는 거라 fromJson이 필요없음
  factory PaginationParams.fromJson(Map<String, dynamic> json)
  => _$PaginationParamsFromJson(json);

  // 오히려 보낼 때 mapping을 해야 해서 toJson이 더 중요
  Map<String, dynamic> toJson() => _$PaginationParamsToJson(this);
}