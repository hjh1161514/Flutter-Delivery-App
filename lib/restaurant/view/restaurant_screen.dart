import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/model/restaurant_model.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get(
        'http://$ip/restaurant',
        options: Options(
            headers: {
              'authorization': 'Bearer $accessToken'
            }
        )
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    // tab 안에 넣을 거리서 (root_tab은 이미 dafault_layout.dart) Scaffold를 사용할 필요 없음
    return Container(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder<List>(
              future: paginateRestaurant(),
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }

                return ListView.separated(
                    itemBuilder: (_, index) { // index를 받아서 각 item 렌더링
                      final item = snapshot.data![index];
                      // parsed
                      final pItem = RestaurantModel(
                          id: item['id'],
                          name: item['name'],
                          thumbUrl: 'http://$ip${item['thumbUrl']}',
                          tags: List<String>.from(item['tags']),
                          priceRange: RestaurantPriceRange.values.firstWhere(
                                  (e) => e.name == item['priceRange']
                          ),
                          ratings: item['ratings'],
                          ratingsCount: item['ratingsCount'],
                          deliveryTime: item['deliveryTime'],
                          deliveryFee: item['deliveryFee']
                      );

                      return RestaurantCard(
                        image: Image.network(
                          pItem.thumbUrl,
                          fit: BoxFit.cover,
                        ),
                        name: pItem.name,
                        tags: pItem.tags,
                        ratingsCount: pItem.ratingsCount,
                        deliveryTime: pItem.deliveryTime,
                        deliveryFee: pItem.deliveryFee,
                        ratings: pItem.ratings,
                      );
                    },
                    separatorBuilder: (_, index) { // 각각 아이템 사이사이 빌드
                      return SizedBox(height: 16.0);
                    },
                    itemCount: snapshot.data!.length // 아이템 갯수
                );
              },
            )
        ),
      ),
    );
  }
}
