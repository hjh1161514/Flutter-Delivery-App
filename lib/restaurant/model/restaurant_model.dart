// 3가지 값만 존재하니까 enum 사용
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/const/data.dart';

// 현재 파일 이름 - 중간에 g 필수
// 터미널에 flutter pub run build_runner build 실행 // flutter pub run build_runner build watch를 하면 파일을 저장할 때마다 자동 build
// part 파일을 지정한 코드를 생성할 수 있는 모든 파일에서 코드 생성
part 'restaurant_model.g.dart';

enum RestaurantPriceRange {
  expensive,
  medium,
  cheap,
}

@JsonSerializable() // 자동으로 코드 생성
class RestaurantModel {
  final String id;
  final String name;
  // .g파일은 바꿀 수 없음.
  // 전환하는 방식을 변경하고 싶은 속성 위에 JsonKey 사용
  // JsonKey 후 명령어 재실행
  @JsonKey(
    fromJson: pathToUrl, // fromJson이 실행될 때 실행하고 싶은 함수
  )
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  // json으로부터 instance를 만듦
  factory  RestaurantModel.fromJson(Map<String, dynamic> json)
  => _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this); // 현재 class를 instance로 넣어줌 = this

  static pathToUrl(String value) { // static은 필수
    return 'http://$ip$value';
  }

  /// JsonSerializable로 .g파일을 만들면서 아래 코드가 .g 파일에서 실행되게 됨
  // factory RestaurantModel.fromJson({
  //   required Map<String,
  //       dynamic> json, // dart에서는 json값을 넣어줄 때 타입은 항상 Map<String,dynamic> json
  // }) {
  //   return RestaurantModel(
  //       id: json['id'],
  //       name: json['name'],
  //       thumbUrl: 'http://$ip${json['thumbUrl']}',
  //       tags: List<String>.from(json['tags']),
  //       priceRange: RestaurantPriceRange.values.firstWhere(
  //       (e) => e.name == json['priceRange']
  //       ),
  //       ratings: json['ratings'],
  //       ratingsCount: json['ratingsCount'],
  //       deliveryTime: json['deliveryTime'],
  //       deliveryFee: json['deliveryFee'],
  //   );}
}