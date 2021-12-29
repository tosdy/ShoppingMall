// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, avoid_print, prefer_is_empty

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';
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
    if (productModels.length != 0) {
      productModels.clear();
    } else {}

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
          : haveData
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
            Navigator.pushNamed(context, MyConstant.rountAddProduct)
                .then((value) => loadValueFromAPI()),
        child: Text('Add'),
      ),
    );
  }

  String CreateURL(String string) {
    String result = string.substring(1, string.length - 1);
    List<String> strings = result.split(',');
    String URL = '${MyConstant.domain}/shoppingmall${strings[0]}';
    print('image : $URL');
    return URL;
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
              height: constraints.maxWidth * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(
                      title: productModels[index].name,
                      textStyle: MyConstant().h2Style()),
                  Container(
                    width: constraints.maxWidth * 0.5,
                    height: constraints.maxWidth * 0.4,
                    // child: Image.network(
                    //   CreateURL(productModels[index].images),
                    //   fit: BoxFit.cover,
                    // ),
                    child: CachedNetworkImage(
                      imageUrl: CreateURL(productModels[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) => Showimage(
                        path: MyConstant.image5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              padding: EdgeInsets.all(4),
              width: constraints.maxWidth * 0.5 - 4,
              height: constraints.maxWidth * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowTitle(
                      title: 'Price: ${productModels[index].price} THB',
                      textStyle: MyConstant().h2Style()),
                  ShowTitle(
                      title: productModels[index].detail,
                      textStyle: MyConstant().h3Style()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit_outlined,
                          size: 36,
                          color: MyConstant.dark,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          confirmDialogDelete(productModels[index]);
                        },
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          size: 36,
                          color: MyConstant.dark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> confirmDialogDelete(ProductModel productModel) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: CachedNetworkImage(
            imageUrl: CreateURL(productModel.images),
            placeholder: (context, url) => ShowProgress(),
          ),
          title: ShowTitle(
              title: 'Delete ${productModel.name} ?',
              textStyle: MyConstant().h2Style()),
          subtitle: ShowTitle(
              title: productModel.detail, textStyle: MyConstant().h3Style()),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String id = productModel.id;
              print("Delete id : $id");
              String apiDeleteProductWhereId =
                  '${MyConstant.domain}/shoppingmall/deleteProductWhereId.php?isAdd=true&id=$id';
              await Dio().get(apiDeleteProductWhereId).then((value) {
                Navigator.pop(context);
                loadValueFromAPI();
              });
            },
            child: Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          )
        ],
      ),
    );
  }
}
