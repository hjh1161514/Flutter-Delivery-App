import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String id;

  const RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  
  @override
  void initState() {
    super.initState();
    
    // 상세 정보를 가져옴
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));

    if (state == null) {
      return DefaultLayout(
          child: Center(
            child: CircularProgressIndicator(),
          )
      );
    }

    return DefaultLayout(
        title: '떡볶이',
        child: CustomScrollView( // 두 개의 스크롤 뷰를 하나의 스크롤이 되는 것처럼 하기 위해 사용
          slivers: [
            renderTop(
              model: state,
            ),
            if (state is RestaurantDetailModel)
            renderLabel(),
            if (state is RestaurantDetailModel)
              renderProducts(
                products: state.products
              ),
          ],
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
    required RestaurantModel model,
  }) {
    return SliverToBoxAdapter( // 일반 위젯을 넣기 위해 사용
      child: RestaurantCard.fromModel(
        model: model,
        isDetail: true,
      ),
    );
  }
}
