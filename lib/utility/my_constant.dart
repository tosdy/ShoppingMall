// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyConstant {
  //Genneral
  static String appName = "Shopping Mall";
  //Rount
  static String rountAuthen = '/authen';
  static String rountCreateAccount = '/createAccount';
  static String rountBuyerService = '/buyerService';
  static String rountSalerService = '/saleService';
  static String rountRiderService = '/riderService';

  //image
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String avatar = 'images/avatar.png';

  //Domain
  static String domain =
      'https://4b55-2001-fb1-50-456d-91ac-46c5-a248-42fd.ngrok.io';

//Color
  static Color primary = Color(0xff9e9d24);
  static Color dark = Color(0xff6c6f00);
  static Color light = Color(0xffd2ce56);

  //Stlyle
  TextStyle h1Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);

  TextStyle h2Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w700);

  TextStyle h2WhiteStyle() =>
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700);

  TextStyle h3Style() =>
      TextStyle(fontSize: 14, color: dark, fontWeight: FontWeight.normal);

  TextStyle h3WhiteStyle() => TextStyle(
      fontSize: 14, color: Colors.white, fontWeight: FontWeight.normal);

  //Button Style
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      );
}
