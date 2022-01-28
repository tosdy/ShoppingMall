// ignore_for_file: prefer_const_constructors, prefer_if_null_operators

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ComfirmAddWallet extends StatefulWidget {
  const ComfirmAddWallet({Key? key}) : super(key: key);

  @override
  _ComfirmAddWalletState createState() => _ComfirmAddWalletState();
}

class _ComfirmAddWalletState extends State<ComfirmAddWallet> {
  String? dateTimeStr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrnttime();
  }

  void findCurrnttime() {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    setState(() {
      dateTimeStr = dateFormat.format(dateTime);
    });
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          newHeadTitle(),
          newDateTime(),
          Spacer(),
          newImage(),
          Spacer(),
          newButton(),
        ],
      ),
    );
  }

  Container newButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        child: Text('Confirm Add Wallet'),
      ),
    );
  }

  Row newImage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.add_a_photo)),
        Container(
          width: 200,
          height: 200,
          child: Showimage(path: MyConstant.image6),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.add_photo_alternate)),
      ],
    );
  }

  ShowTitle newDateTime() {
    return ShowTitle(
      title: dateTimeStr == null ? 'dd/MM/yyyy HH:mm' : dateTimeStr!,
      textStyle: MyConstant().h2BlueStyle(),
    );
  }

  ShowTitle newHeadTitle() {
    return ShowTitle(
        title: 'Current Date Payment', textStyle: MyConstant().h1Style());
  }
}
