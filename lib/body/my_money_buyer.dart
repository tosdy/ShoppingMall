// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/body/approve.dart';
import 'package:shoppingmall/body/wait.dart';
import 'package:shoppingmall/body/wallet.dart';
import 'package:shoppingmall/models/wallet_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_no_data.dart';
import 'package:shoppingmall/widgets/show_process.dart';

class MyMoneyBuyer extends StatefulWidget {
  const MyMoneyBuyer({Key? key}) : super(key: key);

  @override
  _MyMoneyBuyerState createState() => _MyMoneyBuyerState();
}

class _MyMoneyBuyerState extends State<MyMoneyBuyer> {
  int indexWidget = 0;
  var widgets = <Widget>[];

  var titles = <String>['Wallet', 'Approve', 'Wait'];
  var iconDatas = <IconData>[
    Icons.account_balance_wallet,
    Icons.fact_check,
    Icons.hourglass_bottom
  ];

  int approvedWallet = 0;
  int waitApproved = 0;
  bool load = true;
  bool haveData = false;

  List<WalletModel> aproveWalletModels =
      []; // var aproveWalletModels = <WalletModel>[];
  List<WalletModel> waitApproveWalletModels = [];

  Future<void> readAllWallet() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idBuyer = preferences.getString('id');

    print('###idBuyer = $idBuyer');

    var apiUrl =
        '${MyConstant.domain}/shoppingmall/getWalletWhereIdBuyer.php?isAdd=true&idBuyer=$idBuyer';

    await Dio().get(apiUrl).then((value) {
      if (value.toString() != 'null') {
        for (var item in json.decode(value.data)) {
          WalletModel model = WalletModel.fromMap(item);

          switch (model.status) {
            case 'Approve':
              approvedWallet = approvedWallet + int.parse(model.money);
              aproveWalletModels.add(model);
              break;
            case 'WaitOrder':
              waitApproved = waitApproved + int.parse(model.money);
              waitApproveWalletModels.add(model);
              break;
            default:
          }
        }

        print('###approvedWallet = $approvedWallet');
        print('###waitApproved = $waitApproved');

        widgets.add(Wallet(
          approvedWallet: approvedWallet,
          waitApproveWallet: waitApproved,
        ));
        widgets.add(Approve(
          walletModels: aproveWalletModels,
        ));
        widgets.add(Wait(
          walletModels: waitApproveWalletModels,
        ));

        setState(() {
          haveData = true;
          load = false;
        });
      } else {
        setState(() {
          haveData = false;
          load = false;
        });
      }
    });
  }

  var bottonNavigationBarItems = <BottomNavigationBarItem>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllWallet();
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
      body: load
          ? ShowProgress()
          : haveData
              ? widgets[indexWidget]
              : ShowNoData(title: 'No Data', pathImage: MyConstant.image4),
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
