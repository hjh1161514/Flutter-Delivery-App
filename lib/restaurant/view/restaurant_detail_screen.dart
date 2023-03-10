import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '떡볶이',
      child: Column(
        children: [
          RestaurantCard(
              image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
              name: '불떡',
              tags: ['떡볶이', '맛있음'],
              ratingsCount: 100,
              deliveryTime: 30,
              deliveryFee: 3000,
              ratings: 4.5,
              isDetail: true,
              detail: '맛떡',
          ),
        ],
      ),
    );
  }
}
