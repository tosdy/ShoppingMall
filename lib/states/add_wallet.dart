import 'package:flutter/material.dart';
import 'package:shoppingmall/body/bank.dart';
import 'package:shoppingmall/body/creditcard.dart';
import 'package:shoppingmall/body/promtpay.dart';
import 'package:shoppingmall/utility/my_constant.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({Key? key}) : super(key: key);

  @override
  _AddWalletState createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  @override
  List<Widget> widgets = [Bank(), Promtpay(), CreditCard()];
  List<IconData> icons = [Icons.money, Icons.payment, Icons.book];
  List<String> titles = ['Bank', 'Promptpay', 'Credit'];
  int indexPosition = 0;
  List<BottomNavigationBarItem> bottomNavigationBarItems = [];

  @override
  void initState() {
    super.initState();
    int i = 0;
    for (var item in titles) {
      bottomNavigationBarItems
          .add(createBottomNavigationBarItem(icons[i], item));
      i++;
    }
  }

  BottomNavigationBarItem createBottomNavigationBarItem(
          IconData iconData, String string) =>
      BottomNavigationBarItem(
        icon: Icon(iconData),
        label: string,
      );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Wallet form ${titles[indexPosition]}'),
      ),
      body: widgets[indexPosition],
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: MyConstant.dark),
        unselectedIconTheme: IconThemeData(color: MyConstant.light),
        selectedItemColor: MyConstant.dark,
        unselectedItemColor: MyConstant.light,
        items: bottomNavigationBarItems,
        currentIndex: indexPosition,
        onTap: (value) {
          setState(() {
            indexPosition = value;
          });
        },
      ),
    );
  }
}
