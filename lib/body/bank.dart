import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/nav_confirm_add_waller.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class Bank extends StatefulWidget {
  const Bank({Key? key}) : super(key: key);

  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildTitle(),
          buildBBLBank(),
          buildKBank(),
        ],
      ),
      floatingActionButton: NavConfirmAddWallet(),
    );
  }

  Container buildKBank() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 150,
      child: Center(
        child: Card(
          color: Colors.green.shade50,
          child: ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('images/kbank.svg'),
              ),
            ),
            title: ShowTitle(
                title: 'ธนาคาร กสิกร สาขาบิ๊กซีบางนา',
                textStyle: MyConstant().h2Style()),
            subtitle: ShowTitle(
                title: 'หมายเลขบัญชี 123-45-00-111',
                textStyle: MyConstant().h2Style()),
          ),
        ),
      ),
    );
  }

  Widget buildBBLBank() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 150,
      child: Center(
        child: Card(
          color: Colors.indigo.shade50,
          child: ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset('images/bbl.svg'),
              ),
            ),
            title: ShowTitle(
                title: 'ธนาคาร กรุงเทพ สาขาบิ๊กซีบางนา',
                textStyle: MyConstant().h2Style()),
            subtitle: ShowTitle(
                title: 'หมายเลขบัญชี 123-45-00-111',
                textStyle: MyConstant().h2Style()),
          ),
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ShowTitle(
          title: 'การโอนเงินเข้า บัญชีธนาคาร',
          textStyle: MyConstant().h1Style()),
    );
  }
}
