// ignore_for_file: prefer_const_constructors, prefer_void_to_null, unused_local_variable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/states/add_product.dart';
import 'package:shoppingmall/states/add_wallet.dart';
import 'package:shoppingmall/states/authen.dart';
import 'package:shoppingmall/states/buyer_service.dart';
import 'package:shoppingmall/states/create_account.dart';
import 'package:shoppingmall/states/edit_profile_saler.dart';
import 'package:shoppingmall/states/rider_service.dart';
import 'package:shoppingmall/states/saler_service.dart';
import 'package:shoppingmall/states/show_cart.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:flutter/services.dart';

final Map<String, WidgetBuilder> map = {
  MyConstant.rountAuthen: (BuildContext context) => Authen(),
  MyConstant.rountCreateAccount: (BuildContext context) => CreateAccount(),
  MyConstant.rountBuyerService: (BuildContext context) => BuyerService(),
  MyConstant.rountSalerService: (BuildContext context) => SalerService(),
  MyConstant.rountRiderService: (BuildContext context) => RiderService(),
  MyConstant.rountAddProduct: (BuildContext context) => AddProductState(),
  MyConstant.rountEditProfileSaler: (BuildContext context) =>
      EditProfileSaler(),
  MyConstant.rountShowCart: (BuildContext context) => ShowCart(),
  MyConstant.rountAddWallet: (BuildContext context) => AddWallet(),
};

String? initialRount;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? type = preferences.getString('type');
  print('###(main) type ==> $type');
  if (type?.isEmpty ?? true) {
    initialRount = MyConstant.rountAuthen;
    runApp(MyApp());
  } else {
    switch (type) {
      case 'seller':
        initialRount = MyConstant.rountSalerService;
        runApp(MyApp());
        break;
      case 'buyer':
        initialRount = MyConstant.rountBuyerService;
        runApp(MyApp());
        break;
      case 'rider':
        initialRount = MyConstant.rountRiderService;
        runApp(MyApp());
        break;
      default:
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        MaterialColor(0xff6c6f00, MyConstant.mapMaterialColor);
    _portraitModeOnly();
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRount,
      theme: ThemeData(primarySwatch: materialColor),
    );
  }

  @override
  void dispose() {
    _enableRotation();
  }

  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _enableRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
}
