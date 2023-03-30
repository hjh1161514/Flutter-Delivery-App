import 'const/data.dart';

class DataUtils{
  static String pathToUrl(String value) { // static은 필수
    return 'http://$ip$value';
  }

  // dynamic으로 인식되기 때문에 List paths
  // List를 String으로 캐스트하면 무조건 String 타입이 들어와야 함
  // 근데 dynamic으로 데이터를 가져왔을 때 (= 서버로부터 데이터를 가져왔을 때)
  // 타입이 뭐가 될 지 몰라 dynamic으로 사용
  // <String>으로 직접 변환
  static List<String> listPathsToUrls(List paths) {
    return paths.map((e) => pathToUrl(e)).toList();
  }
}