import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';

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
          child: FutureBuilder<List> (
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              return ListView.separated(
                  itemBuilder: (_, index) { // index를 받아서 각 item 렌더링
                    final item = snapshot.data![index];

                    return RestaurantCard(
                      image: Image.network(
                        'http://$ip${item['thumbUrl']}',
                        fit: BoxFit.cover,
                      ),
                      name: item['name'],
                      tags: List<String>.from(item['tags']), // TODO
                      ratingsCount: item['ratingsCount'],
                      deliveryTime: item['deliveryTime'],
                      deliveryFee: item['deliveryFee'],
                      ratings: item['ratings'],
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
