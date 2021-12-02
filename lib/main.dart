import 'package:flutter/material.dart';
import 'package:shoppingmall/states/authen.dart';
import 'package:shoppingmall/states/buyer_service.dart';
import 'package:shoppingmall/states/create_account.dart';
import 'package:shoppingmall/states/rider_service.dart';
import 'package:shoppingmall/states/saler_service.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:flutter/services.dart';

final Map<String, WidgetBuilder> map = {
  '/authen': (BuildContext context) => Authen(),
  '/createAccount': (BuildContext context) => CreateAccount(),
  '/buyerService': (BuildContext context) => BuyerService(),
  '/saleService': (BuildContext context) => SalerService(),
  '/riderService': (BuildContext context) => RiderService(),
};

String? initialRount;

void main() {
  initialRount = MyConstant.rountAuthen;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRount,
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
