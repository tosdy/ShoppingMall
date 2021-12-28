// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_process.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowProductSeller extends StatefulWidget {
  const ShowProductSeller({Key? key}) : super(key: key);

  @override
  _ShowProductSellerState createState() => _ShowProductSellerState();
}

class _ShowProductSellerState extends State<ShowProductSeller> {
  bool load = true;
  bool haveData = false;
  List<ProductModel> productModels = [];
  @override
  void initState() {
    super.initState();
    loadValueFromAPI();
  }

  Future<Null> loadValueFromAPI() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String idSeller = preferences.getString('id')!;

    String apiGetProductWhereIdSeller =
        '${MyConstant.domain}/shoppingmall/getProductWhereIdSeller.php?isAdd=true&idSeller=$idSeller';

    await Dio().get(apiGetProductWhereIdSeller).then((value) {
      if (value.toString() == 'null') {
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);
          print('Product Name : ${model.name}');
          setState(() {
            load = false;
            haveData = true;
            productModels.add(model);
          });
        }
      }
    });

    // await Dio().get(apiGetProductWhereIdSeller).then((value) {
    //   if (value.toString != 'null') {
    //     print("value = $value ");
    //     for (var item in json.decode(value.data)) {
    //       ProductModel model = ProductModel.fromMap(item);
    //       print('name Product : ${model.name}');
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? ShowProgress()
          : haveData!
              ? LayoutBuilder(
                  builder: (context, constraints) => buildListVIew(constraints),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'No Product',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'Please Add Product',
                          textStyle: MyConstant().h2Style()),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, MyConstant.rountAddProduct),
        child: Text('Add'),
      ),
    );
  }

  ListView buildListVIew(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: productModels.length,
      itemBuilder: (context, index) => Card(
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              child: ShowTitle(
                  title: productModels[index].name,
                  textStyle: MyConstant().h2Style()),
            ),
            Container(
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(
                      title: 'Price: ${productModels[index].price} THB',
                      textStyle: MyConstant().h2Style()),
                  ShowTitle(
                      title: productModels[index].detail,
                      textStyle: MyConstant().h3Style()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
