import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class NavConfirmAddWallet extends StatelessWidget {
  const NavConfirmAddWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      //height: 80,
      child: InkWell(
        onTap: () => Navigator.pushNamedAndRemoveUntil(
            context, MyConstant.rountConfirmAddWallet, (route) => false),
        child: Card(
          color: MyConstant.light,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(MyConstant.image6),
                ShowTitle(title: 'Cofirm'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
