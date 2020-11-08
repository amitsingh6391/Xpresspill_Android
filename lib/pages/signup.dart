import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/components/alertBox.dart';
import 'package:my_xpresspill/components/loader.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:my_xpresspill/services/validateService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _autoValidate = false;
  double borderWidth = 1.0;
  final _formKey = GlobalKey<FormState>();
  HashMap userValues = new HashMap<String, String>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  DateTime selectedDate = DateTime(1980);

  ValidateService validateService = ValidateService();
  UserService userService = UserService();

  bool dobpress = false;
  BuildContext scaffoldContext;
  var dob;

  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  _selectDate(BuildContext context) async {             //Selectdate function is used for select used DOB
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(2002),
      builder: (BuildContext context, Widget child) {
            return Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                    primary:primaryColor2, 
                    onPrimary: Colors.white,
                    surface: primaryColor,
                    onSurface: Colors.black,
                    ),
              dialogBackgroundColor:Colors.white,
              ),
              child: child,
            );
          },
    );
    if (picked != null && picked != selectedDate)     //we cheched that user select their DOB 
      setState(() {
        selectedDate = picked;
        userValues['dob'] = selectedDate.toIso8601String();

        dobpress = true;
      });
  }

  setBorder(double width, Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: BorderSide(width: width, color: color));
  }

  signup() async {                      //when user fill their details when he press on signup
    if (this._formKey.currentState.validate()) {     //this function will be invoke.
      _formKey.currentState.save();
      Loader.showLoadingScreen(context, _keyLoader);
      await userService.signup(userValues);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      int statusCode = userService.statusCode;

      print(statusCode);
      if (statusCode == 400) {            //we check statuscode which will be return from firebase
        AlertBox alertBox = AlertBox(userService.msg);  //according to status code we will show diffrent
        return showDialog(                     //msg . if statuscode==200 means everything is right and 
            context: context,                  //we show them msg your account is successfully created 
            builder: (BuildContext context) {     //otherwise we will display them message whatever 
              return alertBox.build(context);     //return from firebase.
            });
      } else {
        print(statusCode);

        Fluttertoast.showToast(
          msg: "Your Account is Successfully Created  Login Now",
          fontSize: 15,
          backgroundColor: primaryColor,
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );

        Navigator.pushReplacementNamed(context, '/');
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

 

  InputDecoration customFormField(String hintText) {
    return InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.all(20.0),
        errorBorder: this.setBorder(1.0, Colors.red),
        focusedErrorBorder: this.setBorder(1.0, Colors.red),
        focusedBorder: this.setBorder(2.0, primaryColor),
        enabledBorder: this.setBorder(1.0, primaryColor));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, false),
        ),
        iconTheme: IconThemeData(color: primaryColor2),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 15.0),
          child: Form(
            key: _formKey, //here we define our form key which will be validate at a time of signup
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
                      fontFamily: primaryFontFamily),
                ),
                SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 10.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: customFormField('First name'),
                        validator: (value) =>
                            validateService.isEmptyField(value),
                        onSaved: (String val) {                       //in every textfield we are defined 
                                                                //validator which validate required condition
                          userValues['firstName'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: primaryFontFamily),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        decoration: customFormField('Last name'),
                        validator: (value) =>
                            validateService.isEmptyField(value),
                        onSaved: (String val) {
                          userValues['lastName'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: primaryFontFamily),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        decoration: customFormField('E-mail Address'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            validateService.validateEmail(value),
                        onSaved: (String val) {
                          userValues['email'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: primaryFontFamily),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        decoration: customFormField('Phone number'),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) =>
                            validateService.validatePhoneNumber(value),
                        onSaved: (String val) {
                          userValues['contactNumber'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: primaryFontFamily),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: customFormField('Password'),
                        validator: (value) =>
                            validateService.validatePassword(value),
                        onSaved: (String val) {
                          userValues['password'] = val;
                        },
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: primaryFontFamily),
                      ),
                      SizedBox(height: 30.0),
                      TextFormField(
                        controller: confirmpassword,
                        obscureText: true,
                        decoration: customFormField('Confirm - Password'),
                        
                        validator: (val) {
                          return val == password.text
                              ? null
                              : "Your Password Not Matched";
                        },
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: primaryFontFamily),
                      ),






                      SizedBox(height: 30.0),


                      FlatButton(
                        height: 60.0,
                        minWidth: 250,
                        onPressed: () {
                          _selectDate(
                              context); // we need to convert in rotation....
                        },
                        child: dobpress
                            ? Text(
                                'select date of Bearth\n ${selectedDate.toLocal()}'
                                    .split(' ')[4],
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: primaryFontFamily),
                              )
                            : Text(
                                "DOB",
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontFamily: primaryFontFamily),
                              ),
                        textColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: primaryColor,
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      SizedBox(height: 50.0),
                      ButtonTheme(
                        minWidth: 250.0,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                              side: BorderSide(color: primaryColor2)),
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          color: primaryColor2,
                          textColor: Colors.white,     //when each details will be filled thn user will be 
                          child: Text(                 //press on signup button and then this signup function
                            'Sign Up',
                            style: TextStyle(           //will be invoke.
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: primaryFontFamily),
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

  void createSnackBar() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: new Text(
          "Incorrect OTP ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black));
  }
}
