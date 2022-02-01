// ignore_for_file: prefer_const_constructors, prefer_if_null_operators

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class ComfirmAddWallet extends StatefulWidget {
  const ComfirmAddWallet({Key? key}) : super(key: key);

  @override
  _ComfirmAddWalletState createState() => _ComfirmAddWalletState();
}

class _ComfirmAddWalletState extends State<ComfirmAddWallet> {
  String? dateTimeStr;
  File? file;
  var formKey = GlobalKey<FormState>();

  String? idBuyer;
  TextEditingController moneyControler = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findCurrnttime();
    findUser();
  }

  Future<void> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idBuyer = preferences.getString('id');
  }

  void findCurrnttime() {
    DateTime dateTime = DateTime.now();
    DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    setState(() {
      dateTimeStr = dateFormat.format(dateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Add Wallet'),
        leading: IconButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, MyConstant.rountBuyerService, (route) => false),
            icon: Platform.isIOS
                ? Icon(Icons.arrow_back_ios)
                : Icon(Icons.arrow_back)),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              newHeadTitle(),
              newDateTime(),
              Spacer(),
              buildNewMoney(),
              Spacer(),
              newImage(),
              Spacer(),
              newButton(),
            ],
          ),
        ),
      ),
    );
  }

  Row buildNewMoney() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          child: TextFormField(
            controller: moneyControler,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please Fill Money';
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              label: ShowTitle(title: 'Money'),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Container newButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (file == null) {
              MyDialog().normalDialog(
                  context, 'Error', 'กรุณาถ่ายภาพ หรือ เลิือกภาพจาก Gallary');
            } else {
              processUploadAndInsertData();
            }
          }
        },
        child: Text('Confirm Add Wallet'),
      ),
    );
  }

  Future<void> processUploadAndInsertData() async {
    //Uploas Image to server
    String apiSaveSlip = '${MyConstant.domain}/shoppingmall/saveSlip.php';
    String nameSlip = 'slip${Random().nextInt(1000000)}.jpg';

    MyDialog().showProgressDialog(context);
    try {
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameSlip);

      FormData data = FormData.fromMap(map);
      await Dio().post(apiSaveSlip, data: data).then((value) async {
        Navigator.pop(context);

        //Insert Data to database
        var pathSlip = '/slip/$nameSlip';
        var status = 'WaitOrder';
        String apiInsert =
            '${MyConstant.domain}/shoppingmall/insertWallet.php?isAdd=true&idBuyer=$idBuyer&datePay=$dateTimeStr&money=${moneyControler.text.trim()}&pathSlip=$pathSlip&status=$status';
        await Dio().get(apiInsert).then((value) {
          MyDialog(funcAction: () => success()).actionDialog(
              context, 'Confirm Success', 'Confirm Add Wallet Success ');
        });
      });
    } catch (e) {}
  }

  void success(){
    Navigator.pushNamedAndRemoveUntil(context, MyConstant.rountBuyerService, (route) => false)

  }

  Future<void> processTakePhoto(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row newImage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
            onPressed: () => processTakePhoto(ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo,
              size: 40,
            )),
        Container(
          width: 300,
          height: 300,
          child: file == null
              ? Showimage(path: MyConstant.image6)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => processTakePhoto(ImageSource.gallery),
          icon: Icon(
            Icons.add_photo_alternate,
            size: 40,
          ),
        ),
      ],
    );
  }

  ShowTitle newDateTime() {
    return ShowTitle(
      title: dateTimeStr == null ? 'dd/MM/yyyy HH:mm' : dateTimeStr!,
      textStyle: MyConstant().h2BlueStyle(),
    );
  }

  ShowTitle newHeadTitle() {
    return ShowTitle(
        title: 'Current Date Payment', textStyle: MyConstant().h1Style());
  }
}
