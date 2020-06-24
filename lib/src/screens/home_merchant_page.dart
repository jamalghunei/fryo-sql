import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shared/buttons.dart';

class HomeMerchantPage extends StatelessWidget {
  final _scKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scKey,
      appBar: AppBar(
        leading: PopupMenuButton(itemBuilder: (_) {
          return <PopupMenuItem>[
            PopupMenuItem(
                child: InkWell(
                    onTap: () {
                      SharedPreferences.getInstance().then((value) {
                        value.clear();
                        Navigator.of(context).pushReplacementNamed('/signin');
                      });
                    },
                    child: Text('Sign Out')))
          ];
        }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: froyoOutlineBtn('add product', () {
              Navigator.of(context).pushNamed('/AddProductPage').then((value) {
                if (value) {
                  _scKey.currentState.showSnackBar(
                      SnackBar(content: Text('success add product')));
                }
              });
            }),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: froyoOutlineBtn('Orders', () {}),
          ),
        ],
      ),
    );
  }
}
