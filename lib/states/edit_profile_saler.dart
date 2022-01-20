// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_collection_literals

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingmall/main.dart';
import 'package:shoppingmall/models/user_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/widgets/show_image.dart';
import 'package:shoppingmall/widgets/show_process.dart';
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
  LatLng? latLng;
  final formKey = GlobalKey<FormState>();
  File? file;

  @override
  void initState() {
    super.initState();
    findUser();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();

    if (position != null) {
      setState(() {
        latLng = LatLng(position.latitude, position.longitude);
      });
    }
  }

  Future<Position?> findPosition() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = null;
    }
    return position;
  }

  Future<Null> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? user = preferences.getString('user');

    String apiGetUser =
        '${MyConstant.domain}/shoppingmall/getUserWhereUser.php?isAdd=true&user=$user';

    await Dio().get(apiGetUser).then((value) {
      print('### Value = $value');
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
        actions: [
          IconButton(
            onPressed: () => processEditProfile(),
            icon: Icon(Icons.edit),
            tooltip: 'Edit Profile Saler',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                buildTitle('General'),
                buildName(constraints),
                buildAddress(constraints),
                buildPhone(constraints),
                buildTitle('Avatar : '),
                buildAvatar(constraints),
                buildTitle('Location :'),
                buildMap(constraints),
                buildButtonEditProfile(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton buildButtonEditProfile() {
    return ElevatedButton.icon(
        onPressed: () => processEditProfile(),
        icon: Icon(
          Icons.edit,
          color: MyConstant.light,
        ),
        label: Text('Edit Saler'));
  }

  Row buildMap(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          margin: EdgeInsets.symmetric(
            vertical: 16,
          ),
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 0.5,
          child: latLng == null
              ? ShowProgress()
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: latLng!,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {},
                  markers: <Marker>[
                    Marker(
                      markerId: MarkerId('id'),
                      position: latLng!,
                      infoWindow: InfoWindow(
                          title: 'Your Location',
                          snippet:
                              'lat : ${latLng!.latitude} Lng : ${latLng!.longitude}'),
                    )
                  ].toSet(),
                ),
        ),
      ],
    );
  }

  Future<Null> processEditProfile() async {
    print("Button Edit Process!!");

    MyDialog().showProgressDialog(context);

    if (formKey.currentState!.validate()) {
      if (file == null) {
        print('### Not Change Avatar');
        editValueToMySQL(userModel!.avatar);
      } else {
        print('###Change Avatar');
        String apiSaveAvatar =
            '${MyConstant.domain}/shoppingmall/saveAvatar.php';
        List<String> nameAvatars = userModel!.avatar.split('/');
        String nameFile = nameAvatars[nameAvatars.length - 1];
        nameFile = 'edit${Random().nextInt(100)}$nameFile';
        print('###FileNameEdit = $nameFile');

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: nameFile);
        FormData formData = FormData.fromMap(map);

        await Dio().post(apiSaveAvatar, data: formData).then((value) {
          print('###upload success');
          String pathAvatar = '/shoppingmall/avatar/$nameFile';
          editValueToMySQL(pathAvatar);
        });
      }
    }
  }

  Future<Null> editValueToMySQL(String pathAvatar) async {
    String apiEditProfile =
        '${MyConstant.domain}/shoppingmall/editProfileSalerWhereId.php?isAdd=true&id=${userModel!.id}&name=${nameController.text}&address=${addressController.text}&phone=${phoneController.text}&avatar=$pathAvatar&lat=${latLng!.latitude}&lng=${latLng!.longitude}';
    await Dio().get(apiEditProfile).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  Future<Null> createAvatar({ImageSource? source}) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: source!, maxWidth: 800, maxHeight: 800);

      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildAvatar(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              IconButton(
                onPressed: () => createAvatar(source: ImageSource.camera),
                icon: Icon(Icons.add_a_photo),
                color: MyConstant.dark,
              ),
              Container(
                height: constraints.maxWidth * 0.6,
                width: constraints.maxWidth * 0.6,
                child: userModel == null
                    ? ShowProgress()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: userModel!.avatar == null
                            ? Showimage(path: MyConstant.avatar)
                            : (file == null
                                ? buildShowImageNetwork()
                                : Image.file(file!)),
                      ),
              ),
              IconButton(
                onPressed: () => createAvatar(source: ImageSource.gallery),
                icon: Icon(Icons.add_photo_alternate),
                color: MyConstant.dark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  CachedNetworkImage buildShowImageNetwork() {
    return CachedNetworkImage(
      imageUrl: '${MyConstant.domain}${userModel!.avatar}',
      placeholder: (context, url) => ShowProgress(),
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Name is empty';
              } else {
                return null;
              }
            },
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Address is empty';
              } else {
                return null;
              }
            },
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
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Phone is empty';
              } else {
                return null;
              }
            },
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
