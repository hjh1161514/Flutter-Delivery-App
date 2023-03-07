import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_delivery_app/common/view/root_tab.dart';
import 'package:flutter_delivery_app/user/view/login_screen.dart';

import '../const/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    checkToken();
  }

  void checkToken() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    if (refreshToken == null || accessToken == null) {
      if(context.mounted) {
        // pushAndRemoveUntil : 쌓인 페이지를 다 지우고 이동
        Navigator.of(context).pushAndRemoveUntil( // pushAndRemoveUntil(가고싶은라우터, )
            MaterialPageRoute(builder: (_) => LoginScreen(),
            )
            , (route) => false
        );
      }

    } else {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil( // pushAndRemoveUntil(가고싶은라우터, )
            MaterialPageRoute(builder: (_) => RootTab(),
            )
            , (route) => false
        );
      }
    }
  }

  void deleteToken() async {
    await storage.deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: PRIMARY_COLOR,
      child: SizedBox(
        width: MediaQuery.of(context).size.width, // 너비 최대화

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'asset/img/logo/logo.png',
              width: MediaQuery.of(context).size.width/2,
            ),
            const SizedBox(height: 16.0,),
            CircularProgressIndicator( //HJ: 로딩 돌아가는 동그라미
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
