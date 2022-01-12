// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/body/my_money_buyer.dart';
import 'package:shoppingmall/body/my_order_buyer.dart';
import 'package:shoppingmall/body/show_all_shop_buyer.dart';
import 'package:shoppingmall/utility/my_constant.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

  UserAccountsDrawerHeader buildHeader() =>
      UserAccountsDrawerHeader(accountName: null, accountEmail: null);
}
