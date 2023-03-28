import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// provider가 생성이 될 때 FlutterSecureStorage가 반환이 되면 이 하나의 값을 가지고 프로젝트에서 돌려서 사용
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => FlutterSecureStorage());