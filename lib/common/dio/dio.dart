import 'package:dio/dio.dart';
import 'package:flutter_delivery_app/common/const/data.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor{
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
  });

  // 1) 요청을 보낼 때
  // 요청이 보내질 떄마다
  // 요청의 Header에 accessToken: true라는 값이 있다면
  // 실제 토큰을 가져와서 storage에서 authorization: bearer $token으로 헤더 변경
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

    // return 전에 써야 요청을 보내기 전에 실행 가능
    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      // 진짜 token으로 변경
      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      // 진짜 token으로 변경
      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return super.onRequest(options, handler); // 요청이 보내지는 순간
  }

  // 2) 응답을 받을 때
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('[RES] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    return super.onResponse(response, handler);
  }

  // 3) 에러가 났을 때
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // 401 에러가 났을 때 (status code)
    // 토큰을 재발급 받는 시도를 하고 토큰이 재발급되면
    // 다시 새로운 토큰으로 요청 시도
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    // refreshToken도 만료 or 오류
    // rehreshToken이 아예 없음
    if (refreshToken == null) {
      // 에러를 돌려주기
      // 에러를 던질 떄는 handler.reject를 사용
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token'; // 토큰을 refresh하려다가 에러 => refreshToken 오류

    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      try{
        final resp = await dio.post(
            'http://$ip/auth/token',
            options: Options(
                headers: {
                  'authorization': 'Bearer $refreshToken',
                }
            )
        );

        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        // 토큰 변경하기
        options.headers.addAll({
          'authorization': 'bearer $accessToken',
        });

        // 새로 발급받은 accessToken을 저장
        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        // 보냈던 요청 다시 보내기
        final response = await dio.fetch(options);

        // 요청이 잘 끝났
        return handler.resolve(response);

      } on DioError catch(e){
        return handler.reject(e);
      }
    }
    return handler.reject(err);
  }
}