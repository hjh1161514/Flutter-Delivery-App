import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '떡볶이',
      child: CustomScrollView( // 두 개의 스크롤 뷰를 하나의 스크롤이 되는 것처럼 하기 위해 사용
        slivers: [
          renderTop(),
          renderLabel(),
          renderProducts(),
        ],
      )
      // Column(
      //   children: [
      //     RestaurantCard(
      //         image: Image.asset('asset/img/food/ddeok_bok_gi.jpg'),
      //         name: '불떡',
      //         tags: ['떡볶이', '맛있음'],
      //         ratingsCount: 100,
      //         deliveryTime: 30,
      //         deliveryFee: 3000,
      //         ratings: 4.5,
      //         isDetail: true,
      //         detail: '맛떡',
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //       child: ProductCard(),
      //     )
      //   ],
      // ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard(),
              );
            },
          childCount: 10,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop() {
    return SliverToBoxAdapter( // 일반 위젯을 넣기 위해 사용
      child: RestaurantCard(
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
    );
  }
}
