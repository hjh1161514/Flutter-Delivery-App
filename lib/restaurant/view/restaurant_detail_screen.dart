import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/common/utils/pagination_utils.dart';
import 'package:flutter_delivery_app/product/component/product_card.dart';
import 'package:flutter_delivery_app/rating/component/rating_card.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:flutter_delivery_app/restaurant/provider/restaurant_rating_provider.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletons/skeletons.dart';

import '../../rating/model/rating_model.dart';
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
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // 상세 정보를 가져옴
    ref.read(restaurantProvider.notifier).getDetail(id: widget.id);

    controller.addListener(listener);
  }
  
  void listener() {
    PaginationUtils.paginate(
        controller: controller, 
        provider: ref.read(restaurantRatingProvider(widget.id).notifier)
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantDetailProvider(widget.id));
    final ratingsState = ref.watch(restaurantRatingProvider(widget.id));

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
          controller: controller,
          slivers: [
            renderTop(
              model: state,
            ),
            if (state is! RestaurantDetailModel) renderLoading(),
            if (state is RestaurantDetailModel)
            renderLabel(),
            if (state is RestaurantDetailModel)
              renderProducts(
                products: state.products
              ),
            // 맨 밑에 있기 때문에 복잡한 조건문을 넣을 필요가 없음
            // 에러가 나지 않으면 언젠가 로딩이 됨
            if(ratingsState is CursorPagination<RatingModel>)
            renderRatings(models: ratingsState.data),
          ],
        )
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
            (_, index) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RatingCard.fromModel(
                model: models[index],
              ),
            ),
          childCount: models.length
        ),
      )
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SkeletonParagraph(
                  style: SkeletonParagraphStyle(
                    lines: 5,
                    padding: EdgeInsets.zero, // skeleton 자체 padding 제거
                  ),
                ),
              )
          ),
        ),
      ),
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
