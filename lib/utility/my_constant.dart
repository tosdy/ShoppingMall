// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

class MyConstant {
  //Genneral
  static String appName = "Shopping Mall";
  static String urlPromtpay = 'https://promptpay.io/0888888888.png';
  //Rount
  static String rountAuthen = '/authen';
  static String rountCreateAccount = '/createAccount';
  static String rountBuyerService = '/buyerService';
  static String rountSalerService = '/saleService';
  static String rountRiderService = '/riderService';
  static String rountAddProduct = '/addProduct';
  static String rountEditProfileSaler = '/editProfileSaler';
  static String rountShowCart = '/showCart';
  static String rountAddWallet = '/addWallet';
  static String rountConfirmAddWallet = '/confirmAddWallet';

  //image
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/image5.png';
  static String image6 = 'images/image6.png';
  static String avatar = 'images/avatar.png';

  //Domain
  static String domain = 'https://8cb8-184-82-205-0.ngrok.io';

  //omise
  static String publicKey = 'pkey_test_5qlrb7anllgfmbc415m';
  static String secretKey = 'skey_test_5qlrb7anktc8yff1yhy';

//Color
  static Color primary = Color(0xff9e9d24);
  static Color dark = Color(0xff6c6f00);
  static Color light = Color(0xffd2ce56);

  static Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(108, 111, 0, 0.1),
    100: Color.fromRGBO(108, 111, 0, 0.2),
    200: Color.fromRGBO(108, 111, 0, 0.3),
    300: Color.fromRGBO(108, 111, 0, 0.4),
    400: Color.fromRGBO(108, 111, 0, 0.5),
    500: Color.fromRGBO(108, 111, 0, 0.6),
    600: Color.fromRGBO(108, 111, 0, 0.7),
    700: Color.fromRGBO(108, 111, 0, 0.8),
    800: Color.fromRGBO(108, 111, 0, 0.9),
    900: Color.fromRGBO(108, 111, 0, 1.0),
  };

  //Stlyle
  TextStyle h1Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);

  TextStyle h2Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w700);

  TextStyle h2WhiteStyle() =>
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700);

  TextStyle h2RedStyle() =>
      TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.w700);

  TextStyle h2BlueStyle() =>
      TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.w700);

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
