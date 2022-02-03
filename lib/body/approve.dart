// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/models/wallet_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_list_wallet.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class Approve extends StatefulWidget {
  final List<WalletModel> walletModels;

  const Approve({Key? key, required this.walletModels}) : super(key: key);

  @override
  _ApproveState createState() => _ApproveState();
}

class _ApproveState extends State<Approve> {
  List<WalletModel>? approveWalletModes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    approveWalletModes = widget.walletModels;
    print('###Approve total : ${approveWalletModes!.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: approveWalletModes?.isEmpty ?? true
          ? ShowTitle(
              title: 'No Money Approve', textStyle: MyConstant().h1Style())
          : showListWallet(
              WalletModes: approveWalletModes,
            ),
    );
  }
}
