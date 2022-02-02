// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shoppingmall/body/approve.dart';
import 'package:shoppingmall/body/wait.dart';
import 'package:shoppingmall/body/wallet.dart';
import 'package:shoppingmall/utility/my_constant.dart';

class MyMoneyBuyer extends StatefulWidget {
  const MyMoneyBuyer({Key? key}) : super(key: key);

  @override
  _MyMoneyBuyerState createState() => _MyMoneyBuyerState();
}

class _MyMoneyBuyerState extends State<MyMoneyBuyer> {
  int indexWidget = 0;
  var widgets = <Widget>[Wallet(), Approve(), Wait()];

  var titles = <String>['Wallet', 'Approve', 'Wait'];
  var iconDatas = <IconData>[
    Icons.account_balance_wallet,
    Icons.fact_check,
    Icons.hourglass_bottom
  ];

  var bottonNavigationBarItems = <BottomNavigationBarItem>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUpBottonBar();
  }

  void setUpBottonBar() {
    int index = 0;
    for (var title in titles) {
      bottonNavigationBarItems.add(
        BottomNavigationBarItem(
          label: title,
          icon: Icon(
            iconDatas[index],
          ),
        ),
      );
      index++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets[indexWidget],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyConstant.dark,
        unselectedItemColor: MyConstant.light,
        onTap: (value) {
          setState(() {
            indexWidget = value;
            print('### Select = $indexWidget');
          });
        },
        currentIndex: indexWidget,
        items: bottonNavigationBarItems,
      ),
    );
  }
}
