import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  // 외부에서 받아오는 변수
  final String? hintText; // text가 없는 걸 원할 수 있으니 ?로
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    required this.onChanged, // required로 필수 매개변수
    this.autofocus = false,
    this.obscureText = false, // 기본값은 false
    this.hintText,
    this.errorText,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide( // 테두리
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      )
    );

    return TextFormField(
      cursorColor: PRIMARY_COLOR, // 커서 색상
      obscureText: obscureText, // 비밀번호 입력할 때
      autofocus: autofocus, // 첫 화면에서 포커스 여부. 화면에 위젯이 오는 순간
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle( // hintText의 스타일
          color: BODY_TEXT_COLOR,
          fontSize: 14.0,
        ),
        fillColor: INPUT_BG_COLOR, // 배경색이라고 생각하기. filled와 같이 사용해야 함
        // false : 배경색 없음. true: 배경색 있음
        filled: true,
        // 동그랗게 border
        // border: 모든 Input 상태의 기본 스타일 세팅
        border: baseBorder,
        // 포커스 되었을 때의 상태
        focusedBorder:  baseBorder.copyWith( // cobyWith은 앞의 속성을 그대로 사용하면서 바꾸고 싶은 부분(아래)만 변경
          borderSide: baseBorder.borderSide.copyWith( // baseBorder는 그대로 borderSide 값만 변경. -> baseBorder의 borderSide로 변경.
            color: PRIMARY_COLOR, // 색만 변경
          )
        )
      ),
    );
  }
}
