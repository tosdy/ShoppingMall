import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class MyDialog {
  Future<Null> alertLocationService(BuildContext cotext) async {
    showDialog(
      context: cotext,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Showimage(path: MyConstant.image4),
          title: ShowTitle(
            title: 'Location sevice ของคุณปิดอยู่',
            textStyle: MyConstant().h2Style(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                //Navigator.pop(context);
                await Geolocator
                    .openLocationSettings(); //Open Location seting in setup menu
                exit(0);
              },
              child: Text('OK')),
        ],
      ),
    );
  }
}
