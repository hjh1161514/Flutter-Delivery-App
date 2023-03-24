import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';
import 'package:flutter_delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // tab 안에 넣을 거리서 (root_tab은 이미 dafault_layout.dart) Scaffold를 사용할 필요 없음
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<CursorPagination<RestaurantModel>>(
              future: ref.watch(restaurantRepositoryProvider).paginate(),
              builder: (context, AsyncSnapshot<CursorPagination<RestaurantModel>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );;
                }

                return ListView.separated(
                    itemBuilder: (_, index) { // index를 받아서 각 item 렌더링
                      final pItem = snapshot.data!.data[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RestaurantDetailScreen(
                                id: pItem.id
                              ),
                            ),
                          );
                        },
                        child: RestaurantCard.fromModel(
                          model: pItem,
                        ),
                      );
                    },
                    separatorBuilder: (_, index) { // 각각 아이템 사이사이 빌드
                      return SizedBox(height: 16.0);
                    },
                    itemCount: snapshot.data!.data.length // 아이템 갯수
                );
              },
            )
        ),
      ),
    );
  }
}
