// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shoppingmall/widgets/show_signout.dart';

class SalerService extends StatefulWidget {
  const SalerService({Key? key}) : super(key: key);

  @override
  _SalerServiceState createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saler'),
      ),
      drawer: Drawer(
        child: ShowSignOut(),
      ),
    );
  }
}
