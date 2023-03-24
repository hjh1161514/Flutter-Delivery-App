import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/restaurant_provider.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //restaurantProvider는 불러오면 생성. 그 뒤에 기억
    // provider에 요청을 해서 상태 안에 list만 들어옴 -> snapshot.data!.data에서 가져오던 걸 data 안에서 바로 가져오기 가능
    // 참고) FutureBuilder는 snapshot 안에 데이터를 넣음
    final data = ref.watch(restaurantProvider); // 생성이 되어 paginate() 실행 -> 홈 화면에 있는 리스트를 저장할 수 있음

    if(data.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // tab 안에 넣을 거리서 (root_tab은 이미 dafault_layout.dart) Scaffold를 사용할 필요 없음
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
            itemBuilder: (_, index) { // index를 받아서 각 item 렌더링
              final pItem = data[index];

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
            itemCount: data.length // 아이템 갯수
        )
    );
  }
}
