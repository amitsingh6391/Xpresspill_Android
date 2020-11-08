import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/components/alertBox.dart';
import 'package:my_xpresspill/components/loader.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:my_xpresspill/services/validateService.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  HashMap userValues = new HashMap<String, String>();
  bool _autoValidate = false;
  double borderWidth = 2.0;

  ValidateService _validateService = ValidateService();
  UserService _userService = UserService();
 
  login() async {  //loginfunction will be invoked when user will be provide their correct passwprd and email
    if (this._formKey.currentState.validate()) {   //otherwise according to statuscode we will show thm=em errors.
      _formKey.currentState.save();
      Loader.showLoadingScreen(context, _keyLoader);
      await _userService.login(userValues);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      int statusCode = _userService.statusCode;

      if (statusCode == 200) {
        if (_userService.currentUserDetails.isPharmacist) {     //here we will navigate user according to
          Navigator.pushReplacementNamed(context, '/pharmacisthome');  //their status.
        } else if (_userService.currentUserDetails.isAdmin) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (!_userService.currentUserDetails.isAdmin &&
            !_userService.currentUserDetails.isPharmacist)
          Navigator.pushReplacementNamed(context, '/userhome');
      } else {
        AlertBox alertBox = AlertBox(_userService.msg);
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertBox.build(context);
            });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  setBorder(double width, Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
        borderSide: BorderSide(width: width, color: color));
  }

  InputDecoration customFormField(String hintText) {
    return InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(20.0),
        border: InputBorder.none,
        errorBorder: this.setBorder(borderWidth, Colors.red),
        focusedErrorBorder: this.setBorder(borderWidth, Colors.red),
        focusedBorder: this.setBorder(borderWidth, primaryColor),
        enabledBorder: this.setBorder(borderWidth, primaryColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.popAndPushNamed(context, '/')),
        iconTheme: IconThemeData(color: primaryColor),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 15.0),
          child: Form(
            key: _formKey,           //we define our form key for login validation...
            autovalidate: _autoValidate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Sign In',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: primaryFontFamily),
                ),
                SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: customFormField('E-mail '),
                        validator: (value) =>
                            _validateService.isEmptyField(value),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String val) {
                          userValues['email'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: primaryFontFamily),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        obscureText: true,
                        decoration: customFormField('Password'),
                        validator: (value) =>
                            _validateService.isEmptyField(value),
                        onSaved: (String val) {
                          userValues['password'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: primaryFontFamily),
                      ),
                      SizedBox(height: 30.0),
                      Center(
                        child: Column(
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 250.0,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36),
                                    side: BorderSide(color: primaryColor)),
                                padding: EdgeInsets.symmetric(vertical: 20.0),
                                color: primaryColor,
                                textColor: Colors.white,
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: primaryFontFamily),
                                ),
                                onPressed: () {
                                  this.login();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
