import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Showimage extends StatelessWidget {
  final String path;
  const Showimage({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(path);
  }
}
