// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class EditProfileSaler extends StatefulWidget {
  const EditProfileSaler({Key? key}) : super(key: key);

  @override
  _EditProfileSalerState createState() => _EditProfileSalerState();
}

class _EditProfileSalerState extends State<EditProfileSaler> {
  UserModel? userModel;
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    findUser();
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString('user');

    String apiGetUser =
        '${MyConstant.domain}/shoppingmall/getUserWhereUser.php?isAdd=true&user=$user';

    await Dio().get(apiGetUser).then((value) {
      print('## Value = $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          nameController.text = userModel!.name;
          addressController.text = userModel!.address;
          phoneController.text = userModel!.phone;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Saller'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => ListView(
          padding: EdgeInsets.all(16),
          children: [
            buildTitle('General'),
            buildName(constraints),
            buildAddress(constraints),
            buildPhone(constraints),
          ],
        ),
      ),
    );
  }

  Row buildName(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name: ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildAddress(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            maxLines: 3,
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Address: ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone: ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  ShowTitle buildTitle(String s) {
    return ShowTitle(
      title: s,
      textStyle: MyConstant().h2Style(),
    );
  }
}
