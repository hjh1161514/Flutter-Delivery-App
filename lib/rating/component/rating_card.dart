import 'package:flutter/material.dart';
import 'package:flutter_delivery_app/common/const/colors.dart';

class RatingCard extends StatelessWidget {
  // NetworkImage나 AssetImage으로 CircleAvatar 타입이 ImageProvider
  final ImageProvider avatarImage;
  // 리스트로 위젯 이미지를 보여줄 때
  final List<Image> images;
  final int rating;
  final String email;
  final String content;

  const RatingCard({
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        const SizedBox(height: 8.0,),
        _Body(
          content: content,
        ),
        _Images(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;

  const _Header({
    required this.avatarImage,
    required this.email,
    required this.rating,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(width: 8.0,),
        Expanded( // 나머지 공간을 모두 차지하게 하기 위해
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
            5, (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined, // rating 값보다 작은 index면 별을 칠하지 않도록
            color: PRIMARY_COLOR,
        ))
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    required this.content,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible( // 최대 사이즈를 적용하기 위해 사용. 문장이 길어지면 다음 줄로 넘어가게 할 수 있음
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  const _Images({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


