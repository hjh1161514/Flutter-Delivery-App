
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_delivery_app/common/layout/default_layout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/view/root_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    // localhost
    final emulatorIp = '10.0.2.2:3000';
    final simulatorIp = '127.0.0.1:3000';

    final ip = Platform.isIOS ? simulatorIp : emulatorIp;

    return DefaultLayout(
        child: SingleChildScrollView( // 스크롤 가능하도록
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // 스크롤 시 키보드가 없어지도록
          child: SafeArea( // TODO
            top: true,
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Title(),
                  const SizedBox(height: 16.0),
                  _SubTitle(),
                  Image.asset(
                    'asset/img/misc/logo.png',
                    width: MediaQuery.of(context).size.width / 3 * 2 // MediaQuery.of(context).size.width: 전체 화면 사이즈 -> 3분의2
                  ),
                  CustomTextFormField(
                    hintText: '이메일을 입력해주세요.',
                    onChanged: (String value) {
                      username = value;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  CustomTextFormField(
                    hintText: '비밀번호를 입력해주세요.',
                    onChanged: (String value) {
                      password = value;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                      onPressed: () async { // 서버 통신에서는 async, await 필수
                        // ID:비밀번호
                        final rawString = '$username:$password';

                        // 일반 string값을 base64로 변환
                        // string값을 넣어서 string값을 반환
                        Codec<String, String> stringToBase64 = utf8.fuse(base64);

                        String token = stringToBase64.encode(rawString);

                        final resp = await dio.post('http://$ip/auth/login',
                          options: Options(
                            headers: {
                              'authorization' : 'Basic $token',
                            },
                          )
                        );

                        final refreshToken = resp.data['refreshToken']; // body = resp.data
                        final accessToken = resp.data['accessToken'];

                        await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
                        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

                        // 화면 이동
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => RootTab(),
                          ),
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                      child: Text(
                        '로그인',
                      )
                  ),
                  TextButton(
                      onPressed: () async {
                        final refreshToekn = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3RAY29kZWZhY3RvcnkuYWkiLCJzdWIiOiJmNTViMzJkMi00ZDY4LTRjMWUtYTNjYS1kYTlkN2QwZDkyZTUiLCJ0eXBlIjoicmVmcmVzaCIsImlhdCI6MTY3ODE2NTMwNSwiZXhwIjoxNjc4MjUxNzA1fQ.FeYQBPAvOVZQinItOASMUE2vfKkAGooqvGiWU6ETaSg';
                        final resp = await dio.post('http://$ip/auth/token',
                            options: Options(
                              headers: {
                                'authorization' : 'Bearer $refreshToekn',
                              },
                            )
                        );

                        print(resp.data);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: Text(
                        '회원가입'
                      )
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}

// private하기 때문에 class명 앞에 _
class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        '환영합니다!',
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인 해주세요.\n오늘도 성공적인 주문이 되길:)',
      style: TextStyle(
        fontSize: 16,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
