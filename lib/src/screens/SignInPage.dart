import 'package:flutter/material.dart';
import 'package:fryo/src/helper_database.dart';
import 'package:fryo/src/screens/home_merchant_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/inputFields.dart';
import 'package:page_transition/page_transition.dart';
import './SignUpPage.dart';
import './Dashboard.dart';

class SignInPage extends StatefulWidget {
  final String pageTitle;

  SignInPage({Key key, this.pageTitle}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var _keyForm = GlobalKey<FormState>();
  var _scKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          title: Text('Sign In',
              style: TextStyle(
                  color: Colors.grey, fontFamily: 'Poppins', fontSize: 15)),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: SignUpPage()));
              },
              child: Text('Sign Up', style: contrastText),
            )
          ],
        ),
        body: Form(
          key: _keyForm,
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 18, right: 18),
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Welcome Back!', style: h3),
                        fryoTextInput('Email', onChanged: (value) {
                          _email = value;
                        }, validator: (value) {
                          if (value.isEmpty) {
                            return 'fill filed';
                          }
                          return null;
                        }),
                        fryoPasswordInput('Password', onChanged: (value) {
                          _password = value;
                        }, validator: (value) {
                          if (value.isEmpty) {
                            return 'fill filed';
                          }
                          return null;
                        }),
                        FlatButton(
                          onPressed: () {},
                          child:
                              Text('Forgot Password?', style: contrastTextBold),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 15,
                      right: -15,
                      child: FlatButton(
                        onPressed: () async {
                          if (_keyForm.currentState.validate()) {
                            var result = await HelperDatabase.helperDatabase
                                .signIn(_email, _password);
                            if (result == null) {
                              _scKey.currentState.showSnackBar(SnackBar(
                                  content: Text('errro email or password')));
                            } else {
                              SharedPreferences shared =
                                  await SharedPreferences.getInstance();
                              await shared.setBool('state', true);
                              await shared.setInt('id', result.id);
                              await shared.setInt('typeAccount', result.type);
                              if (result.type == 1){
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: Dashboard()));
                              }else{
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: HomeMerchantPage()));
                              }

                            }
                          }
                        },
                        color: primaryColor,
                        padding: EdgeInsets.all(13),
                        shape: CircleBorder(),
                        child: Icon(Icons.arrow_forward, color: white),
                      ),
                    )
                  ],
                ),
                height: 260,
                width: double.infinity,
                decoration: authPlateDecoration,
              ),
            ],
          ),
        ));
  }
}
