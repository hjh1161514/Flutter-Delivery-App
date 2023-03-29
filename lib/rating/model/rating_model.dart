import 'package:flutter_delivery_app/common/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../user/model/user_model.dart';

part 'rating_model.g.dart';

@JsonSerializable()
class RatingModel{
  // restaurant/{rid}/rating api
  final String id;
  final UserModel user;
  final int rating;
  final String content;
  @JsonKey(
    fromJson: DataUtils.listPathsToUrls,
  )
  final List<String> imgUrls;

  RatingModel({
    required this.id,
    required this.user,
    required this.rating,
    required this.content,
    required this.imgUrls,
  });
  
  factory RatingModel.fromJson(Map<String, dynamic> json)
  => _$RatingModelFromJson(json);
}