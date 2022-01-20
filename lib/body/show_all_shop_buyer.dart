// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/states/show_product_buyer.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_process.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowAllShopBuyer extends StatefulWidget {
  const ShowAllShopBuyer({Key? key}) : super(key: key);

  @override
  _ShowAllShopBuyerState createState() => _ShowAllShopBuyerState();
}

class _ShowAllShopBuyerState extends State<ShowAllShopBuyer> {
  bool load = true;
  List<UserModel> userModels = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readApiAllShop();
  }

  Future<Null> readApiAllShop() async {
    String urlAPI = '${MyConstant.domain}/shoppingmall/getUserWhereSaler.php';

    try {
      await Dio().get(urlAPI).then((value) {
        setState(() {
          load = false;
        });
        var result = json.decode(value.data); // change unicode => text
        for (var item in result) {
          UserModel model = UserModel.fromMap(item);
          //print('Shop Name : ${model.name}');
          setState(() {
            userModels.add(model);
          });
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : GridView.builder(
              itemCount: userModels.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  childAspectRatio: 2 / 3, maxCrossAxisExtent: 200),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  print('###Click form ${userModels[index].name}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShowProductBuyer(userModel: userModels[index]),
                      ));
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  Showimage(path: MyConstant.avatar),
                              placeholder: (context, url) => ShowProgress(),
                              fit: BoxFit.cover,
                              imageUrl:
                                  '${MyConstant.domain}${userModels[index].avatar}'),
                        ),
                        ShowTitle(
                            title: cutWord(userModels[index].name),
                            textStyle: MyConstant().h3Style()),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String cutWord(String name) {
    String result = name;
    if (result.length > 14) {
      result = result.substring(0, 10);
      result = '$result ...';
    }
    return result;
  }
}
