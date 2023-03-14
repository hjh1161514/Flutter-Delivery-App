import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';

import '../../common/const/data.dart';

// RestaurantModel에 있는 속성들을 중복으로 선언하지 않고 상속을 통해 값을 세팅
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

  // json을 넣기만 하면 자동으로 mapping이 되기 위해 factory를 만듦
  factory RestaurantDetailModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return RestaurantDetailModel(
        id: json['id'],
        name: json['name'],
        thumbUrl: 'http://$ip${json['thumbUrl']}',
        tags: List<String>.from(json['tags']),
        priceRange: RestaurantPriceRange.values.firstWhere(
                (e) => e.name == json['priceRange']
        ),
        ratings: json['ratings'],
        ratingsCount: json['ratingsCount'],
        deliveryTime: json['deliveryTime'],
        deliveryFee: json['deliveryFee'],
        detail: json['detail'],
        products: json['products'].map<RestaurantProductModel>( //<제너릭>을 넣지 않으면 dynamic으로 자동으로 설정.
            (x) =>
                RestaurantProductModel(
                    id: x['id'],
                    name: x['name'],
                    imgUrl: x['imgUrl'],
                    detail: x['detail'],
                    price: x['price'],
                ),
        ).toList(),
    );
  }
}

class RestaurantProductModel{
  final String id;
  final String name;
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
}