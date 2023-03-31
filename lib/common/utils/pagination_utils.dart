import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery_app/common/provider/pagination_provider.dart';

class PaginationUtils{
  static void paginate({
    required ScrollController controller,
    required PaginationProvider provider,
}) {
    // 현재 위치가 최대 길이보다 조금 덜 되는 위치까지 왔다면 새로운 데이터를 추가 요청
    if (controller.offset > controller.position.maxScrollExtent - 300) { //offset: 현재 스크롤한 위치, maxScrollExtent: 최대 스크롤 가능한 길이
      provider.paginate(
        fetchMore: true, // 새로운 데이터 추가
      );
    }
  }
}