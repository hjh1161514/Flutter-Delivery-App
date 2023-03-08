import 'package:flutter/material.dart';

// 모든 뷰에 특정 기능을 적용하고 싶을 때 로직 추가
class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white, // backgroundColor가 null이면 white로 설정
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar, // 아래에 탭을 생성할 수 있는 파라미터
    );
  }

  AppBar? renderAppBar() {
    if(title == null) {
      return null;
    } else {
      return AppBar(
        centerTitle: true, // 앱바 타이틀 중앙 정렬
        backgroundColor: Colors.white,
        elevation: 0, // 앞으로 나온 듯한 느낌. 요즘은 없는 것이 트랜드
        title: Text(
          title!, // !: if문으로 null 체크를 했기 떄문에 null이 될 수 없음을 !로 나타냄
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        foregroundColor: Colors.black, // appbar 위에 올라가는 위젯 색상
      );
    }
  }
}
