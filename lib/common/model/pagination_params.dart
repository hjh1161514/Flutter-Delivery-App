
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
  
  factory PaginationParams.fromJson(Map<String, dynamic> json)
  => _$PaginationParamsFromJson(json);
}