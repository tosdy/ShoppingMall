// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:shoppingmall/utility/my_constant.dart';

class AddProductState extends StatefulWidget {
  const AddProductState({Key? key}) : super(key: key);

  @override
  _AddProductStateState createState() => _AddProductStateState();
}

class _AddProductStateState extends State<AddProductState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildProduct(constraints),
                  buildProductPrice(constraints),
                  buildProductDetail(constraints),
                  buildImage(constraints),
                  Container(
                    width: constraints.maxWidth * 0.75,
                    child: ElevatedButton(
                      style: MyConstant().myButtonStyle(),
                      onPressed: () {},
                      child: Text('Add Product'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column buildImage(BoxConstraints constraints) {
    return Column(
      children: [
        Container(
          width: constraints.maxWidth * 0.75,
          height: constraints.maxWidth * 0.75,
          child: Image.asset(MyConstant.image5),
        ),
        Container(
          width: constraints.maxWidth * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 48,
                height: 48,
                child: Image.asset(MyConstant.image5),
              ),
              Container(
                width: 48,
                height: 48,
                child: Image.asset(MyConstant.image5),
              ),
              Container(
                width: 48,
                height: 48,
                child: Image.asset(MyConstant.image5),
              ),
              Container(
                width: 48,
                height: 48,
                child: Image.asset(MyConstant.image5),
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
        ),
      ),
    );
  }

  Widget buildProductPrice(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
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
        ),
      ),
    );
  }

  Widget buildProductDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.75,
      margin: EdgeInsets.only(top: 16),
      child: TextFormField(
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
        ),
      ),
    );
  }
}
