import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/utility/my_dialog.dart';
import 'package:shoppingmall/widgets/nav_confirm_add_waller.dart';
import 'package:shoppingmall/widgets/show_process.dart';
import 'package:shoppingmall/widgets/show_title.dart';

class Promtpay extends StatefulWidget {
  const Promtpay({Key? key}) : super(key: key);

  @override
  _PromtpayState createState() => _PromtpayState();
}

class _PromtpayState extends State<Promtpay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildTitle(),
            buildCopyPromptPay(),
            ShowQRcode(),
            buildDownload(),
          ],
        ),
      ),
      floatingActionButton: NavConfirmAddWallet(),
    );
  }

  ElevatedButton buildDownload() {
    return ElevatedButton(
      onPressed: () async {
        String path = '/sdcard/download';
        try {
          await FileUtils.mkdir([path]);
          await Dio()
              .download(MyConstant.urlPromtpay, '$path/promptpay.png')
              .then((value) => MyDialog().normalDialog(context,
                  'Download Success', 'กรุณาไปที่แอปธนาคารเพื่อทำรายการต่อไป'));
        } catch (e) {
          print('### error : ${e.toString()}');
          MyDialog().normalDialog(context, 'Download Fail', '${e.toString()}');
        }
      },
      child: Text('Download QRcode'),
    );
  }

  Container ShowQRcode() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: CachedNetworkImage(
          placeholder: (context, url) => ShowProgress(),
          imageUrl: MyConstant.urlPromtpay),
    );
  }

  Widget buildCopyPromptPay() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        color: Colors.lime.shade50,
        child: ListTile(
          title: ShowTitle(
            title: '0868975878',
            textStyle: MyConstant().h1Style(),
          ),
          subtitle: ShowTitle(title: 'บัญชี PromptPay'),
          trailing: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '0888888888'));
                MyDialog().normalDialog(
                    context, 'Copy PromtPay', 'Copy PromtPay To Clipboard');
              },
              icon: Icon(
                Icons.copy,
                color: MyConstant.dark,
              )),
        ),
      ),
    );
  }

  ShowTitle buildTitle() {
    return ShowTitle(
      title: 'การโอนเงินโดยใช้ Promptpay',
      textStyle: MyConstant().h2Style(),
    );
  }
}
