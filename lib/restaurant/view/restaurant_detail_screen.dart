import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';

import '../model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  Future <RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '떡볶이',
      child: FutureBuilder<RestaurantDetailModel> (
        future: getRestaurantDetail(),
        builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView( // 두 개의 스크롤 뷰를 하나의 스크롤이 되는 것처럼 하기 위해 사용
            slivers: [
              renderTop(
                model: snapshot.data!,
              ),
              renderLabel(),
              renderProducts(
                products: snapshot.data!.products
              ),
            ],
          );
        },
      )
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

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products
}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (context, index) {
              // model을 가져오는 방법
              final model = products[index];

              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ProductCard.fromModel(
                    model: model,
                ),
              );
            },
          childCount: products.length,
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({
    required RestaurantDetailModel model,
}) {
    return SliverToBoxAdapter( // 일반 위젯을 넣기 위해 사용
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
