import 'package:flutter/material.dart';
import 'package:fryo/src/helper_database.dart';
import 'package:fryo/src/screens/home_merchant_page.dart';
import 'package:fryo/src/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/inputFields.dart';
import 'package:page_transition/page_transition.dart';
import './SignInPage.dart';
import './Dashboard.dart';

class SignUpPage extends StatefulWidget {
  final String pageTitle;

  SignUpPage({Key key, this.pageTitle}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int type = 0;

  var _keyForm = GlobalKey<FormState>();
  var _scKey = GlobalKey<ScaffoldState>();

  String _password = '';

  UserModel _userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: white,
          title: Text('Sign Up',
              style: TextStyle(
                  color: Colors.grey, fontFamily: 'Poppins', fontSize: 15)),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                // Navigator.of(context).pushReplacementNamed('/signin');
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: SignInPage()));
              },
              child: Text('Sign In', style: contrastText),
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
                        Text('Welcome!', style: h3),
                        Text('Let\'s get started', style: taglineText),
                        fryoTextInput('Username', validator: (value) {
                          if (value.isEmpty) {
                            return 'fill filed';
                          }
                          return null;
                        }, onSave: (value) {
                          _userModel = UserModel(type, null, null, value);
                        }),
                        fryoEmailInput('Email Address', validator: (value) {
                          if (value.isEmpty) {
                            return 'fill filed';
                          }
                          return null;
                        }, onSave: (value) {
                          _userModel =
                              UserModel(type, null, value, _userModel.userName);
                        }),
                        fryoPasswordInput('Password',onChanged: (value){
                          _password = value;
                        },
                            validator: (String value) {
                          if (value.isEmpty) {
                            return 'fill filed';
                          }
                          return null;
                        }),
                        Row(
                          children: <Widget>[
                            Flexible(
                                flex: 1,
                                child: RadioListTile(
                                  value: 1,
                                  groupValue: type,
                                  onChanged: (val) {
                                    setState(() {
                                      type = val;
                                    });
                                  },
                                  title: Text('client'),
                                )),
                            Flexible(
                                flex: 1,
                                child: RadioListTile(
                                  value: 2,
                                  groupValue: type,
                                  onChanged: (val) {
                                    setState(() {
                                      type = val;
                                    });
                                  },
                                  title: Text('merchant'),
                                )),
                          ],
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 15,
                      right: -15,
                      child: FlatButton(
                        onPressed: () async{

                        var state =   _keyForm.currentState.validate();
                        if (state){
                          if (type == 0){
                            _scKey.currentState.showSnackBar(SnackBar(content: Text('fill type'),));
                            return;
                          }
                          _keyForm.currentState.save();

                          int id = await HelperDatabase.helperDatabase.signUpUser(_userModel , _password);
                          SharedPreferences shared =
                          await SharedPreferences.getInstance();
                          await shared.setBool('state', true);
                          await shared.setInt('id', id);
                          await shared.setInt('typeAccount', type);
                          if (type == 1){
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

                        },
                        color: primaryColor,
                        padding: EdgeInsets.all(13),
                        shape: CircleBorder(),
                        child: Icon(Icons.arrow_forward, color: white),
                      ),
                    )
                  ],
                ),
                height: 430,
                width: double.infinity,
                decoration: authPlateDecoration,
              ),
            ],
          ),
        ));
  }
}
