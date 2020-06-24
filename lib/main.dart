import 'package:flutter/material.dart';
import 'package:fryo/src/screens/add_product_page.dart';
import 'package:fryo/src/screens/home_merchant_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fryo/src/screens/adress.dart';
import './src/screens/SignInPage.dart';
import './src/screens/SignUpPage.dart';
import './src/screens/HomePage.dart';
import './src/screens/Dashboard.dart';
import './src/screens/ProductPage.dart';
import 'src/screens/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fryo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: FutureBuilder(
        builder: (_, AsyncSnapshot<List<dynamic>> state) {
          var result = state.data[0] as bool;
          if (result) {
            var typeAccount = state.data[1] as int;
            if (typeAccount == 1) {
              return Dashboard();
            } else {
              return HomeMerchantPage();
            }
          }
          return HomePage(
            pageTitle: 'Welcome',
          );
        },
        future: Future(() async {
          SharedPreferences shared = await SharedPreferences.getInstance();
          bool state = shared.getBool('state') ?? false;
          int typeAccount = shared.getInt('typeAccount') ?? 0;
          return [state, typeAccount];
        }),
      ),
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => SignUpPage(),
        '/signin': (BuildContext context) => SignInPage(),
        '/dashboard': (BuildContext context) => Dashboard(),
        '/productPage': (BuildContext context) => ProductPage(),
        '/HomeMerchantPage': (BuildContext context) => HomeMerchantPage(),
        '/AddProductPag': (BuildContext context) => AddProductPag(),
        '/AddProductPage' : (BuildContext context) => AddProductPage()
      },
    );
  }
}
