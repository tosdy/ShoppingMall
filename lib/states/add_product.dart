// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_print, empty_catches, unrelated_type_equality_checks

import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class AddProductState extends StatefulWidget {
  const AddProductState({Key? key}) : super(key: key);

  @override
  _AddProductStateState createState() => _AddProductStateState();
}

class _AddProductStateState extends State<AddProductState> {
  final formKey = GlobalKey<FormState>();
  List<File?> files = [];
  File? file;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  List<String> paths = [];

  @override
  void initState() {
    super.initState();
    initialFile();
  }

  void initialFile() {
    for (var i = 0; i < 4; i++) {
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => processAddProduct(),
              icon: Icon(Icons.cloud_upload))
        ],
        title: Text('Add Product'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildProduct(constraints),
                    buildProductPrice(constraints),
                    buildProductDetail(constraints),
                    buildImage(constraints),
                    addProductButton(constraints)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container addProductButton(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          processAddProduct();
        },
        child: Text('Add Product'),
      ),
    );
  }

  Future<Null> processAddProduct() async {
    if (formKey.currentState!.validate()) {
      bool checkFile = true;
      for (var item in files) {
        if (item == null) {
          checkFile = false;
        }
      }

      if (checkFile) {
        MyDialog().showProgressDialog(context);

        print('### Choose 4 image suucess');
        String apiSaveProduct =
            '${MyConstant.domain}/shoppingmall/saveProduct.php';

        int loop = 0;
        for (var item in files) {
          int i = Random().nextInt(1000000000);
          String nameFile = 'product$i.jpg';
          paths.add('/product/$nameFile');
          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item!.path, filename: nameFile);

          FormData data = FormData.fromMap(map);

          await Dio().post(apiSaveProduct, data: data).then((value) async {
            print('###Upload Success');
            loop++;
            if (loop >= files.length) {
              SharedPreferences preferance =
                  await SharedPreferences.getInstance();
              String idSeller = preferance.getString('id')!;
              String nameSeller = preferance.getString('name')!;
              String name = nameController.text;
              String price = priceController.text;
              String detail = detailController.text;
              String images = paths.toString();
              print('### idSeller = $idSeller | nameSeller = $nameSeller');
              print(
                  '###= name : $nameSeller | price : $price | detail : $detail');
              print('###images : $images');

              String path =
                  '${MyConstant.domain}/shoppingmall/insertProduct.php?isAdd=true&idSeller=$idSeller&nameSeller=$nameSeller&name=$name&price=$price&detail=$detail&images=$images';
              await Dio()
                  .get(path)
                  .then((value) => Navigator.pop(context)); //Previous PAge
              Navigator.pop(context); //Kill Popup Progress
            }
          });
        }
      } else {
        MyDialog()
            .normalDialog(context, 'More Image', 'Please Choose More Image');
      }
    }
  }

  Future<Null> processImagePicker(ImageSource source, int index) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
        files[index] = file;
      });
    } catch (e) {}
  }

  Future<Null> chooseImageDialog(int index) async {
    print('###Click Image : $index');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: Showimage(
            path: MyConstant.image4,
          ),
          title: ShowTitle(
              title: "Source Image: ${index + 1}",
              textStyle: MyConstant().h2Style()),
          subtitle: ShowTitle(
              title: 'Please Tab on camera or Gallery',
              textStyle: MyConstant().h3Style()),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.camera, index);
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  processImagePicker(ImageSource.gallery, index);
                },
                child: Text('Gallery'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 0.75,
          child:
              file == null ? Image.asset(MyConstant.image5) : Image.file(file!),
        ),
        Container(
          width: constraints.maxWidth * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  child: files[0] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(files[0]!),
                  onTap: () => chooseImageDialog(0),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  child: files[1] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(files[1]!),
                  onTap: () => chooseImageDialog(1),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  child: files[2] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(files[2]!),
                  onTap: () => chooseImageDialog(2),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                child: InkWell(
                  child: files[3] == null
                      ? Image.asset(MyConstant.image5)
                      : Image.file(files[3]!),
                  onTap: () => chooseImageDialog(3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProduct(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Product Name';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: 'Product Name :',
          labelStyle: MyConstant().h3Style(),
          prefixIcon: Icon(
            Icons.production_quantity_limits_sharp,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildProductPrice(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: priceController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Product Price';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Product Price :',
          labelStyle: MyConstant().h3Style(),
          prefixIcon: Icon(
            Icons.money_sharp,
            color: MyConstant.dark,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildProductDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
        controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Product Detail';
          } else {
            return null;
          }
        },
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Product Detail :',
          hintStyle: MyConstant().h3Style(),
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
            child: Icon(
              Icons.details_outlined,
              color: MyConstant.dark,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
