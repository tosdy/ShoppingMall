// ignore_for_file: prefer_const_constructors, unnecessary_this

import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class Wallet extends StatefulWidget {
  final int approvedWallet, waitApproveWallet;

  const Wallet(
      {Key? key, required this.approvedWallet, required this.waitApproveWallet})
      : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  int? approveWallet, waitApprovedWallet;

  @override
  void initState() {
    super.initState();
    this.approveWallet = widget.approvedWallet;
    this.waitApprovedWallet = widget.waitApproveWallet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: MyConstant().planBackground(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildListTitle(Icons.wallet_giftcard, 'จำนวนเงินที่ใช้ได้',
                  '$approveWallet bath'),
              buildListTitle(Icons.wallet_membership, 'จำนวนเงินที่รอตรวจสอบ',
                  '$waitApprovedWallet bath'),
              buildListTitle(Icons.grain_sharp, 'จำนวนเงินทั้งหมด',
                  '${approveWallet! + waitApprovedWallet!} bath'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTitle(IconData iconData, String title, String subtitle) {
    return Container(
      width: 300,
      child: Card(
        //color: MyConstant.light,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: ListTile(
            leading: Icon(iconData),
            title: ShowTitle(
              title: title,
              textStyle: MyConstant().h2BlueStyle(),
            ),
            subtitle: ShowTitle(
              title: subtitle,
              textStyle: MyConstant().h1Style(),
            ),
          ),
        ),
      ),
    );
  }
}
