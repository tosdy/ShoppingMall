// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shoppingmall/models/wallet_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_list_wallet.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class Wait extends StatefulWidget {
  final List<WalletModel> walletModels;

  const Wait({Key? key, required this.walletModels}) : super(key: key);

  @override
  _WaitState createState() => _WaitState();
}

class _WaitState extends State<Wait> {
  List<WalletModel>? waitWalletModels;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    waitWalletModels = widget.walletModels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: waitWalletModels?.isEmpty ?? true
          ? ShowTitle(title: 'No Money Wait', textStyle: MyConstant().h1Style())
          : showListWallet(
              WalletModes: waitWalletModels,
            ),
    );
  }
}
