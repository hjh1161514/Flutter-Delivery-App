import 'package:flutter_delivery_app/common/data_utils.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';

part 'restaurant_detail_model.g.dart';

// RestaurantModel에 있는 속성들을 중복으로 선언하지 않고 상속을 통해 값을 세팅
@JsonSerializable()
class RestaurantDetailModel extends RestaurantModel{
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail, //this는 현재 클래스니까. super은 부모 클래스
    required this.products
  });

  // json으로부터 instance를 만듦
  factory  RestaurantDetailModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantDetailModelFromJson(json);
}

@JsonSerializable()
class RestaurantProductModel{
  final String id;
  final String name;
  @JsonKey(
    fromJson: DataUtils.pathToUrl,
  )
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantProductModelFromJson(json);
}