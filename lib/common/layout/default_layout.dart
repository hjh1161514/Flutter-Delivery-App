import 'package:flutter/material.dart';

// 모든 뷰에 특정 기능을 적용하고 싶을 때 로직 추가
class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;

  const DefaultLayout({
    required this.child,
    this.backgroundColor,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white, // backgroundColor가 null이면 white로 설정
      body: child,
    );
  }
}
