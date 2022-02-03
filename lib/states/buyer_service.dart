// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/body/my_money_buyer.dart';
import 'package:shoppingmall/body/my_order_buyer.dart';
import 'package:shoppingmall/body/show_all_shop_buyer.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_process.dart';
import 'package:shoppingmall/widgets/show_signout.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  _BuyerServiceState createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  List<Widget> Widgets = [ShowAllShopBuyer(), MyMoneyBuyer(), MyOrderBuyer()];
  int indexWidget = 0;

  UserModel? userModel;
  @override
  void initState() {
    super.initState();
    findUserLogin();
  }

  Future<void> findUserLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idUserLogin = preferences.getString('id');
    String apiUrl =
        '${MyConstant.domain}/shoppingmall/getUserWhereId.php?isAdd=true&id=$idUserLogin';

    await Dio().get(apiUrl).then((value) async {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          print('###Id user login ${userModel!.id}');
        });
      }

      var apiUrl =
          '${MyConstant.domain}/shoppingmall/getWalletWhereIdBuyer.php?isAdd=true&idBuyer=${userModel!.id}';

      await Dio().get(apiUrl).then((value) {
        if (value.toString() == 'null') {
          print('Data Empty');
          MyDialog(
            funcAction: () {
              Navigator.pop(context);
              return Navigator.pushNamed(context, MyConstant.rountAddWallet);
            },
          ).actionDialog(context, 'No Wallet', 'Please Add Wallet');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, MyConstant.rountShowCart),
            icon: Icon(Icons.shopping_cart),
          ),
        ],
        title: Text('Buyer'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildHeader(),
                buildShowAllShop(),
                buildMyMoney(),
                buildShowMyOrder()
              ],
            ),
            ShowSignOut(),
          ],
        ),
      ),
      body: Widgets[indexWidget],
    );
  }

  ListTile buildShowAllShop() {
    return ListTile(
      leading: Icon(
        Icons.shopping_bag,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'Show Shop',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
          title: 'แสดงร้านค้า ทั้งหมด', textStyle: MyConstant().h3Style()),
      onTap: () => setState(() {
        indexWidget = 0;
        Navigator.pop(context);
      }),
    );
  }

  ListTile buildMyMoney() {
    return ListTile(
      leading: Icon(
        Icons.money,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'My Money',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
          title: 'แสดงจำนวนเงินที่มี', textStyle: MyConstant().h3Style()),
      onTap: () => setState(() {
        indexWidget = 1;
        Navigator.pop(context);
      }),
    );
  }

  ListTile buildShowMyOrder() {
    return ListTile(
      leading: Icon(
        Icons.list,
        size: 36,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'My order',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle:
          ShowTitle(title: 'แสดงการสั่งของ', textStyle: MyConstant().h3Style()),
      onTap: () => setState(() {
        indexWidget = 2;
        Navigator.pop(context);
      }),
    );
  }

  UserAccountsDrawerHeader buildHeader() => UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          radius: 1,
          center: Alignment(-0.8, -0.2),
          colors: [Colors.white, MyConstant.dark],
        ),
      ),
      currentAccountPicture: userModel == null
          ? Showimage(path: MyConstant.avatar)
          : userModel!.avatar.isEmpty
              ? Showimage(path: MyConstant.avatar)
              : CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      '${MyConstant.domain}${userModel!.avatar}'),
                ),
      accountName: ShowTitle(
        title: userModel == null ? '' : userModel!.name,
        textStyle: MyConstant().h2WhiteStyle(),
      ),
      accountEmail: null);
}
