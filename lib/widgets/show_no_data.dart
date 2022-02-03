import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowNoData extends StatelessWidget {
  final String title;
  final String pathImage;

  const ShowNoData({Key? key, required this.title, required this.pathImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: 200,
          child: Showimage(path: pathImage),
        ),
        Center(
            child: ShowTitle(title: title, textStyle: MyConstant().h1Style())),
      ],
    );
  }
}
