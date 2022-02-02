// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Wait extends StatefulWidget {
  const Wait({Key? key}) : super(key: key);

  @override
  _WaitState createState() => _WaitState();
}

class _WaitState extends State<Wait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('wait'),
    );
  }
}
