import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:omise_flutter/omise_flutter.dart';
import 'package:shoppingmall/body/show_order_seller.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/widgets/show_title.dart';
import 'package:http/http.dart' as http;

class CreditCard extends StatefulWidget {
  const CreditCard({Key? key}) : super(key: key);

  @override
  _CreditCardState createState() => _CreditCardState();
}

class _CreditCardState extends State<CreditCard> {
  String? name,
      surname,
      idCard,
      expiredDateMonth,
      expiredDateYear,
      cvc,
      amount,
      expiredDateStr;
  MaskTextInputFormatter idCardMask =
      MaskTextInputFormatter(mask: '####-####-####-####');
  MaskTextInputFormatter expiredDateMask =
      MaskTextInputFormatter(mask: '##/####');
  MaskTextInputFormatter cvcMark = MaskTextInputFormatter(mask: '###');

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildTitle('Name Surname'),
                    buildNameSurname(),
                    buildTitle('Card Number'),
                    formIdCard(),
                    buildExpiredCVC(),
                    buildTitle('Amount :'),
                    formAmount(),
                    //Spacer(),
                    buildButton(),
                  ],
                ),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: [
              //     buildButton(),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      child: Container(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              print('###ID Card = $idCard');
              print('###Expired Month = $expiredDateMonth');
              print('###Expired Year = $expiredDateYear');
              print('###cvc = $cvc');
              getTokenAndChargeOmise();
            }
          },
          child: Text('Add Money'),
        ),
      ),
    );
  }

  Future<void> getTokenAndChargeOmise() async {
    String publicKey = MyConstant.publicKey;
    OmiseFlutter omiseFlutter = OmiseFlutter(publicKey);

    await omiseFlutter.token
        .create('$name $surname', idCard!, expiredDateMonth!, expiredDateYear!,
            cvc!)
        .then((value) async {
      String token = value.id.toString();
      print('###token = $token');

      //Charge Credit User
      String secretKey = MyConstant.secretKey;
      String urlApi = 'https://api.omise.co/charges';
      String basicAuth = 'Basic ' + base64Encode(utf8.encode(secretKey + ":"));
      Map<String, String> headerMap = {};
      headerMap['authorization'] = basicAuth;
      headerMap['Cache-Control'] = 'no-cache';
      headerMap['Content-Type'] = 'application/x-www-form-urlencoded';

      String zero = '00';
      amount = '$amount$zero';

      Map<String, dynamic> data = {};
      data['amount'] = amount;
      data['currency'] = 'thb';
      data['card'] = token;

      Uri uri = Uri.parse(urlApi);
      http.Response response =
          await http.post(uri, headers: headerMap, body: data);

      var resultAPI = json.decode(response.body);
      //print('### Response = $resultAPI');
      print('###status = ${resultAPI['status']}');
    }).catchError((value) {
      String title = value.code;
      String message = value.message;
      MyDialog().normalDialog(context, title, message);
    });
  }

  Widget formAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Amount';
          } else {
            amount = value.trim();
            return null;
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          suffix: ShowTitle(
            title: 'THB',
            textStyle: MyConstant().h2Style(),
          ),
          label: ShowTitle(title: 'Amount'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Container buildExpiredCVC() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          buildSizeBox(30),
          Expanded(
            child: Column(
              children: [buildTitle('Expired Date'), formExpireDate()],
            ),
          ),
          buildSizeBox(8),
          Expanded(
            child: Column(
              children: [
                buildTitle('CVC'),
                formCvc(),
              ],
            ),
          ),
          buildSizeBox(30),
        ],
      ),
    );
  }

  Widget formExpireDate() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Fill Expired Date';
        } else {
          if (expiredDateStr!.length != 6) {
            return 'You entered incorrect';
          } else {
            expiredDateMonth = expiredDateStr!.substring(0, 2);
            expiredDateYear = expiredDateStr!.substring(2, 6);
            int expiredDataInt = int.parse(expiredDateMonth!);
            if (expiredDataInt > 12) {
              return 'You entered incorrect';
            } else {
              expiredDateMonth = expiredDataInt.toString();
              return null;
            }
          }
        }
      },
      onChanged: (value) {
        expiredDateStr = expiredDateMask.getUnmaskedText();
      },
      inputFormatters: [expiredDateMask],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'xx/xxxx',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget formCvc() {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please Fill CVC';
        } else {
          if (cvc!.length != 3) {
            return 'You entered incorrect';
          } else {
            return null;
          }
        }
      },
      onChanged: (value) {
        cvc = cvcMark.getUnmaskedText();
      },
      inputFormatters: [cvcMark],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'xxx',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget formIdCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Card ID';
          } else {
            if (idCard!.length != 16) {
              return 'Please Fill 16 Digit';
            } else {
              return null;
            }
          }
        },
        inputFormatters: [idCardMask],
        onChanged: (value) {
          idCard = idCardMask.getUnmaskedText();
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'xxxx-xxxx-xxxx-xxxx',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Container buildNameSurname() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          buildSizeBox(30),
          formName(),
          buildSizeBox(8),
          formSurName(),
          buildSizeBox(30),
        ],
      ),
    );
  }

  SizedBox buildSizeBox(double width) => SizedBox(
        width: width,
      );

  Widget formName() {
    return Expanded(
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name';
          } else {
            name = value.trim();
            return null;
          }
        },
        decoration: InputDecoration(
          label: ShowTitle(title: 'Name :'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget formSurName() {
    return Expanded(
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Surname';
          } else {
            surname = value.trim();
            return null;
          }
        },
        decoration: InputDecoration(
          label: ShowTitle(title: 'Surname :'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
        title: title,
        textStyle: MyConstant().h2BlueStyle(),
      ),
    );
  }
}
