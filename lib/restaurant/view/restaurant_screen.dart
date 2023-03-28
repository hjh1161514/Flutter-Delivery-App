import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/model/cursor_pagination_model.dart';
import 'package:flutter_delivery_app/restaurant/component/restaurant_card.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/restaurant_provider.dart';

class RestaurantScreen extends  ConsumerStatefulWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  // 스크롤 특정 영역을 알기 위해서
  final ScrollController controller = ScrollController();
  
  @override
  void initState() {
    super.initState();
    
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    print('run');
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치까지 왔다면 새로운 데이터를 추가 요청
    if (controller.offset > controller.position.maxScrollExtent - 300) { //offset: 현재 스크롤한 위치, maxScrollExtent: 최대 스크롤 가능한 길이
      ref.read(restaurantProvider.notifier).paginate(
        fetchMore: true, // 새로운 데이터 추가
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //restaurantProvider는 불러오면 생성. 그 뒤에 기억
    // provider에 요청을 해서 상태 안에 list만 들어옴 -> snapshot.data!.data에서 가져오던 걸 data 안에서 바로 가져오기 가능
    // 참고) FutureBuilder는 snapshot 안에 데이터를 넣음
    final data = ref.watch(restaurantProvider); // 생성이 되어 paginate() 실행 -> 홈 화면에 있는 리스트를 저장할 수 있음

    // 에러 등 다른 상황이 아닌 로딩이 때만
    // 완전 처음 로딩이 때
    if (data is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // 에러
    if (data is CursorPaginationError) {
      return Center(
        child: Text(data.message),
      );
    }

    // CursorPagination
    // CursorPaginationFetchingMore
    // CursorPaginationRefetching

    // 테스팅용 실제 코드x
    final cp = data as CursorPagination;

    // tab 안에 넣을 거리서 (root_tab은 이미 dafault_layout.dart) Scaffold를 사용할 필요 없음
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          controller: controller,
            itemBuilder: (_, index) { // index를 받아서 각 item 렌더링
              final pItem = cp.data[index];

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
            itemCount: cp.data.length // 아이템 갯수
        )
    );
  }
}
