import 'const/data.dart';

class DataUtils{
  static pathToUrl(String value) { // static은 필수
    return 'http://$ip$value';
  }
}