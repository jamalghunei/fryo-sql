import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fryo/src/helper_database.dart';
import 'package:fryo/src/product_model.dart';
import 'package:image_picker/image_picker.dart';
import '../shared/inputFields.dart';
import '../shared/buttons.dart';

class AddProductPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddProductPageState();
  }
}

class _AddProductPageState extends State<AddProductPage> {
  File _image;
  var _keyForm = GlobalKey<FormState>();
  var _scKey = GlobalKey<ScaffoldState>();

  ProductModel _productModel  = new ProductModel(0, '', '', '', '', 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scKey,
      appBar: AppBar(),
      body: Form(
        key: _keyForm,
        child: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: fryoTextInput('Name', onSave: (value) {
                  print(value);

                  _productModel.name = value;
                }, validator: (value) {
                  if (value.isEmpty) {
                    return 'fill filed';
                  }
                  return null;
                })),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: fryoTextInput('price',
                    textInputType: TextInputType.number, onSave: (value) {

                      _productModel.price = double.parse(value);
                }, validator: (value) {
                  if (value.isEmpty) {
                    return 'fill filed';
                  }
                  return null;
                })),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: fryoTextInput('Duscription', onSave: (value) {

                  _productModel.duscription = value;
                }, validator: (value) {
                  if (value.isEmpty) {
                    return 'fill filed';
                  }
                  return null;
                })),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: fryoTextInput('Category', onSave: (value) {
              _productModel.categoryName = value;
                }, validator: (value) {
                  if (value.isEmpty) {
                    return 'fill filed';
                  }
                  return null;
                })),
            SizedBox(
              height: 40,
            ),
            _image != null
                ? Image.file(
                    _image,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.fill,
                  )
                : Container(),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: froyoOutlineBtn('Pick Image', () async {
                  PickedFile image =
                      await ImagePicker().getImage(source: ImageSource.gallery);

                  setState(() {
                    _image = File(image.path);
                  });
                })),
            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: froyoOutlineBtn('Add product', () async {
                  if (_keyForm.currentState.validate()) {
                    if (_image == null) {
                      _scKey.currentState.showSnackBar(SnackBar(
                        content: Text('add image please!'),
                      ));
                      return;
                    }
                    _keyForm.currentState.save();
                    _productModel.image =
                        base64Encode(_image.readAsBytesSync());
                    await HelperDatabase.helperDatabase
                        .addProduct(_productModel);
                    await HelperDatabase.helperDatabase.getProducts();
                    Navigator.of(context).pop(true);
                  }
                }))
          ],
        ),
      ),
    );
  }
}
