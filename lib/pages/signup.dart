import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/components/alertBox.dart';
import 'package:my_xpresspill/components/loader.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:my_xpresspill/services/validateService.dart';



class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  bool _autoValidate = false;
  double borderWidth = 1.0;
  final _formKey = GlobalKey<FormState>();
  HashMap userValues = new HashMap<String,String>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  DateTime selectedDate = DateTime.now();

  ValidateService validateService = ValidateService();
  UserService userService = UserService();

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        userValues['dob']=selectedDate.toIso8601String();
      });
  }

  setBorder(double width, Color color){
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(
            width: width,
            color: color
        )
    );
  }

  signup() async {
    if(this._formKey.currentState.validate()){
      _formKey.currentState.save();
      Loader.showLoadingScreen(context, _keyLoader);
      await userService.signup(userValues);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      int statusCode = userService.statusCode;
      if(statusCode == 400){
        AlertBox alertBox = AlertBox(userService.msg);
        return showDialog(
            context: context,
            builder: (BuildContext context){
              return alertBox.build(context);
            }
        );
      }
      else{
        Navigator.pushReplacementNamed(context, '/');
      }
    }
    else{
      setState(() {
        _autoValidate = true;
      });
    }
  }

  InputDecoration customFormField(String hintText){
    return InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(20.0),
        errorBorder: this.setBorder(1.0, Colors.red),
        focusedErrorBorder: this.setBorder(1.0, Colors.red),
        focusedBorder: this.setBorder(2.0, primaryColor),
        enabledBorder: this.setBorder(1.0, primaryColor)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context,false),
        ),
        iconTheme: IconThemeData(
            color: primaryColor2
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 15.0),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Create new account',
                  style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: primaryFontFamily
                  ),
                ),
                SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: customFormField('First name'),
                        validator: (value) => validateService.isEmptyField(value),
                        onSaved: (String val){
                          userValues['firstName'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: primaryFontFamily
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        decoration: customFormField('Last name'),
                        validator: (value) => validateService.isEmptyField(value),
                        onSaved: (String val){
                          userValues['lastName'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: primaryFontFamily
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        decoration: customFormField('E-mail Address'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => validateService.validateEmail(value),
                        onSaved: (String val){
                          userValues['email'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: primaryFontFamily
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        decoration: customFormField('Phone number'),
                        keyboardType: TextInputType.phone,
                        validator: (value) => validateService.validatePhoneNumber(value),
                        onSaved: (String val){
                          userValues['contactNumber'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: primaryFontFamily
                        ),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        obscureText: true,
                        decoration: customFormField('Password'),
                        validator: (value) => validateService.validatePassword(value),
                        onSaved: (String val){
                          userValues['password'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0,
                            fontFamily: primaryFontFamily
                        ),
                      ),
                      SizedBox(height: 30.0),
                      FlatButton(
                        height: 60.0,
                        minWidth: 250,
                        onPressed: ()=>_selectDate(context),
                        child: Text('Choose Date of Birth\n ${selectedDate.toLocal()}'.split(' ')[4], style: TextStyle(
                            color: Colors.black,
                            fontFamily: primaryFontFamily
                        )
                        ),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(side: BorderSide(
                            color: primaryColor,
                            width: 1,
                            style: BorderStyle.solid
                        ), borderRadius: BorderRadius.circular(50)),
                      ),
                      SizedBox(height: 50.0),
                      ButtonTheme(
                        minWidth: 250.0,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                              side: BorderSide(color: primaryColor2)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          color: primaryColor2,
                          textColor: Colors.white,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: primaryFontFamily
                            ),
                          ),
                          onPressed: () {
                            this.signup();
                          },
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
