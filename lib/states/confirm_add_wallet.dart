import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';

class ComfirmAddWallet extends StatefulWidget {
  const ComfirmAddWallet({Key? key}) : super(key: key);

  @override
  _ComfirmAddWalletState createState() => _ComfirmAddWalletState();
}

class _ComfirmAddWalletState extends State<ComfirmAddWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Add Wallet'),
        leading: IconButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.rountBuyerService, (route) => false),
            icon: Platform.isIOS
                ? Icon(Icons.arrow_back_ios)
                : Icon(Icons.arrow_back)),
      ),
    );
  }
}
