import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/models/product_model.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_process.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowProductBuyer extends StatefulWidget {
  final UserModel userModel;
  const ShowProductBuyer({Key? key, required this.userModel}) : super(key: key);

  @override
  _ShowProductBuyerState createState() => _ShowProductBuyerState();
}

class _ShowProductBuyerState extends State<ShowProductBuyer> {
  UserModel? userModel;
  bool load = true;
  bool? haveProduct;
  List<ProductModel> productModels = [];
  List<List<String>> listImages = [];
  int indexImage = 0;

  @override
  void initState() {
    // TODO: implement initState

    userModel = widget.userModel;
    readApi();
  }

  Future<void> readApi() async {
    String urlApi =
        '${MyConstant.domain}/shoppingmall/getProductWhereIdSeller.php?isAdd=true&idSeller=${userModel!.id}';

    await Dio().get(urlApi).then((value) {
      if (value.toString() == 'null') {
        setState(() {
          haveProduct = false;
          load = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          ProductModel model = ProductModel.fromMap(item);

          String string = model.images;
          string = string.substring(1, string.length - 1);
          List<String> strings = string.split(',');
          int i = 0;
          for (var item in strings) {
            strings[i] = item.trim();
            i++;
          }

          listImages.add(strings);

          setState(() {
            haveProduct = true;
            load = false;
            productModels.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userModel!.name),
      ),
      body: load
          ? ShowProgress()
          : (haveProduct!
              ? ListProduct()
              : Center(
                  child: ShowTitle(
                      title: 'No Prouduct',
                      textStyle: MyConstant().h1Style()))),
    );
  }

  LayoutBuilder ListProduct() {
    return LayoutBuilder(
      builder: (context, constraints) => ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            print('Click Card : $index');
            showAlertDialog(productModels[index], listImages[index]);
          },
          child: Card(
            child: Row(
              children: [
                Container(
                  width: constraints.maxWidth * 0.5 - 8,
                  height: constraints.maxWidth * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: findUrlImage(productModels[index].images),
                      placeholder: (context, url) => ShowProgress(),
                      errorWidget: (context, url, error) =>
                          Showimage(path: MyConstant.image1),
                    ),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * 0.5,
                  height: constraints.maxWidth * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShowTitle(
                          title: productModels[index].name,
                          textStyle: MyConstant().h2Style(),
                        ),
                        ShowTitle(
                          title: 'Pricd = ${productModels[index].price} THB',
                          textStyle: MyConstant().h3Style(),
                        ),
                        ShowTitle(
                          title: 'Detail = ${productModels[index].detail}',
                          textStyle: MyConstant().h3Style(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String findUrlImage(String arrayImage) {
    String string = arrayImage.substring(1, arrayImage.length - 1);
    List<String> strings = string.split(',');
    int index = 0;
    for (var item in strings) {
      strings[index] = item.trim();
      index++;
    }
    String result = '${MyConstant.domain}/shoppingmall${strings[0]}';
    print('image display = $result');
    return result;
  }

  Future<void> showAlertDialog(
      ProductModel productModel, List<String> images) async {
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: ListTile(
                  leading: Showimage(path: MyConstant.image2),
                  title: ShowTitle(
                    title: productModel.name,
                    textStyle: MyConstant().h2Style(),
                  ),
                  subtitle: ShowTitle(
                      title: 'price ${productModel.price} THB',
                      textStyle: MyConstant().h3Style()),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                        placeholder: (context, url) => ShowProgress(),
                        imageUrl:
                            '${MyConstant.domain}/shoppingmall${images[indexImage]}'),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                indexImage = 0;
                              });
                            },
                            icon: Icon(Icons.filter_1),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                indexImage = 1;
                              });
                            },
                            icon: Icon(Icons.filter_2),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                indexImage = 2;
                              });
                            },
                            icon: Icon(Icons.filter_3),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                indexImage = 3;
                              });
                            },
                            icon: Icon(Icons.filter_4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
