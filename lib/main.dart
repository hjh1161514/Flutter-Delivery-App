import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/component/custom_text_form_field.dart';
import 'package:flutter_delivery_app/common/view/splash_screen.dart';
import 'package:flutter_delivery_app/user/view/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // provider 사용을 위해 ProviderScope 사용
      ProviderScope(child: _App())
  );
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // 최상위에는 무조건 MaterialApp이 들어가야 함
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      debugShowCheckedModeBanner: false, // debug 배너 안 보이도록
      home: SplashScreen(),
    );
  }
}
