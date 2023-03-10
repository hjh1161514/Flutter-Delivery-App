import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/restaurant/view/restaurant_screen.dart';

class RootTab extends StatefulWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab>
  with SingleTickerProviderStateMixin{
  late TabController controller; // late: 나중에 입력이 됨. initState에서 필수로 선언하기 때문에 가능. ?을 하면 계속 확인해야 하기 때문에 late가 더 좋음

  int index = 0;

  @override
  void initState() {
    super.initState();

    // length: children에 넣은 값들의 갯수. 컨트롤할 화면 갯수(홈,음식, 주문, 프로필)
    // vsync : controller에 선언하는 state. this를 사용하기 위해 SingleTickerProviderStateMixin 사용 <- this에 에러가 없어지며 현재 class를 넣을 수 있음
    controller = TabController(length: 4, vsync: this);
    
    controller.addListener(tabListener); // controller에서 변경이 될 때마다 실행
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      // tab이 바뀔 때마다 현재 tab을 index에 넣어줌
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed, // shifting: 선택된 tap이 크게 보임
        onTap: (int index){
          controller.animateTo(index); // 화면 이동
        },
        currentIndex: index, // 선택된 것 지정
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필',
          ),
        ],
      ),
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(), // TabBarview에서 스크롤 시에 이동을 막음
        controller: controller,
        children: [
          RestaurantScreen(),
          Container(child: Text('음식')),
          Container(child: Text('주문')),
          Container(child: Text('프로필')),
        ],
      ),
    );
  }
}
