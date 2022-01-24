import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shoppingmall/body/show_order_seller.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_title.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
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
            Spacer(),
            buildButton(),
          ],
        ),
      ),
    );
  }

  Container buildButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          expiredDateMonth = expiredDateStr!.substring(0, 2);
          expiredDateYear = expiredDateStr!.substring(2, 6);
          print('###ID Card = $idCard');
          print('###Expired Month = $expiredDateMonth');
          print('###Expired Year = $expiredDateYear');
          print('###cvc = $cvc');
        },
        child: Text('Add Money'),
      ),
    );
  }

  Widget formAmount() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
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
