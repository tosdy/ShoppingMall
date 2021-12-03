// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ShowProgress extends StatelessWidget {
  const ShowProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
