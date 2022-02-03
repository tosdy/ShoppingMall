import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shoppingmall/models/wallet_model.dart';
import 'package:shoppingmall/utility/my_constant.dart';
import 'package:shoppingmall/widgets/show_title.dart';

import 'show_image.dart';
import 'show_process.dart';

class showListWallet extends StatelessWidget {
  const showListWallet({
    Key? key,
    required this.WalletModes,
  }) : super(key: key);

  final List<WalletModel>? WalletModes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: WalletModes!.length,
      itemBuilder: (context, index) => Card(
        color:
            index % 2 == 0 ? MyConstant.light.withOpacity(0.5) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShowTitle(
                    title: WalletModes![index].money,
                    textStyle: MyConstant().h1Style(),
                  ),
                  Container(
                    width: 150,
                    height: 170,
                    child: CachedNetworkImage(
                        placeholder: (context, url) => ShowProgress(),
                        errorWidget: (context, url, error) =>
                            Showimage(path: MyConstant.image6),
                        imageUrl:
                            '${MyConstant.domain}/shoppingmall/${WalletModes![index].pathSlip}'),
                  )
                ],
              ),
              ShowTitle(
                title: WalletModes![index].datePay,
                textStyle: MyConstant().h1Style(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
