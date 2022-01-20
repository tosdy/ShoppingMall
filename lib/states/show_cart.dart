// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/models/sqlite_model.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/sqlite_helper.dart';
import 'package:shoppingmall/widgets/show_process.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ShowCart extends StatefulWidget {
  const ShowCart({Key? key}) : super(key: key);

  @override
  _ShowCartState createState() => _ShowCartState();
}

class _ShowCartState extends State<ShowCart> {
  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  UserModel? userModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    processReadSQLite();
  }

  Future<Null> processReadSQLite() async {
    await SQLiteHelper().readSQLite().then((value) {
      //print('### Read SQLite Value = $value');
      setState(() {
        load = false;
        sqliteModels = value;
        findDetailSaler();
      });
    });
  }

  Future<void> findDetailSaler() async {
    String idSeller = sqliteModels[0].idSeller;
    print('###idSaler = $idSeller');
    String apiGetUserWhereId =
        '${MyConstant.domain}/shoppingmall/getUserWhereId.php?isAdd=true&id=$idSeller';
    await Dio().get(apiGetUserWhereId).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Cart'),
      ),
      body: load
          ? ShowProgress()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                showSaler(),
                buildHead(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: sqliteModels.length,
                  itemBuilder: (context, index) => Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ShowTitle(
                          title: sqliteModels[index].name,
                          textStyle: MyConstant().h3Style(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowTitle(
                          title: sqliteModels[index].price,
                          textStyle: MyConstant().h3Style(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowTitle(
                          title: sqliteModels[index].amount,
                          textStyle: MyConstant().h3Style(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ShowTitle(
                          title: sqliteModels[index].sum,
                          textStyle: MyConstant().h3Style(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.delete_forever_outlined),
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Container buildHead() {
    return Container(
      decoration: BoxDecoration(color: MyConstant.light),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ShowTitle(
                title: 'Product',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Price',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Amt',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: ShowTitle(
                title: 'Sum',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Padding showSaler() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
        title: userModel == null ? '' : userModel!.name,
        textStyle: MyConstant().h1Style(),
      ),
    );
  }
}
