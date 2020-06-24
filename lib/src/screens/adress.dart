import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fryo/src/helper_database.dart';
import 'package:fryo/src/product_model.dart';
import 'package:fryo/src/shared/adress_model.dart';
import 'package:image_picker/image_picker.dart';
import '../product_model.dart';
import '../shared/inputFields.dart';
import '../shared/styles.dart';
import '../shared/buttons.dart';

class AddProductPag extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddProductPagState();
  }
}

class _AddProductPagState extends State<AddProductPag> {
  File _image;
  var _keyForm = GlobalKey<FormState>();
  var _scKey = GlobalKey<ScaffoldState>();

  adressmodel _adressModel  = new adressmodel(0, '', 0, '', '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scKey,
      appBar: AppBar(
        title:  Text('Add product',style: h4),

      ),

      body: Form(
        key: _keyForm,
        child: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: fryoTextInput('Address Name', onSave: (value) {
                  print(value);

                  _adressModel.adressname = value;
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
                child: fryoTextInput('Adrees cod',
                    textInputType: TextInputType.number, onSave: (value) {

                      _adressModel.adresscode = double.parse(value);
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
                child: fryoTextInput('Address lane', onSave: (value) {

                  _adressModel.adresslane = value;
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
                child: fryoTextInput('Address city', onSave: (value) {
                  _adressModel.adresslane = value;
                }, validator: (value) {
                  if (value.isEmpty) {
                    return 'fill filed';
                  }
                  return null;
                })),
            SizedBox(
              height: 40,
            ),

            SizedBox(
              height: 20,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: froyoOutlineBtn('Add adress', () async {
                  if (_keyForm.currentState.validate()) {
                    await HelperDatabase.helperDatabase
                        .addadress(_adressModel);
                    Navigator.of(context).pop('/ProductPage');
                  }
                }))
          ],
        ),
      ),
    );
  }
}
