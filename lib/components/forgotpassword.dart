import 'package:flutter/material.dart';
import 'package:my_xpresspill/components/alertBox.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/services/userService.dart';

TextStyle forgotstyle(
    {FontWeight weight = FontWeight.normal, Color color = primaryColor}) {
  return TextStyle(
      fontFamily: primaryFontFamily, fontWeight: weight, color: color);
}

class Forgotpassword extends StatelessWidget {
  UserService userservice = UserService();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForgotpasswordScreen()));
      },
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.bottomRight,
          child: Text("Forgot Password", style: forgotstyle()),
        ),
      ),
    );
  }
}

class ForgotpasswordScreen extends StatefulWidget {
  @override
  _ForgotpasswordScreenState createState() => _ForgotpasswordScreenState();
}

class _ForgotpasswordScreenState extends State<ForgotpasswordScreen> {
  double borderWidth = 2.0;

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

  UserService userservice = UserService();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: MediaQuery.of(context).size.height * 0.35),
            Text(
              'Forgot Password',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: primaryFontFamily),
            ),
            SizedBox(height: 50.0),
            TextFormField(
              decoration: customFormField('Enter Your E-mail '),
              controller: email,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(fontSize: 17.0, fontFamily: primaryFontFamily),
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
                        'Submit',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: primaryFontFamily),
                      ),
                      onPressed: () {
                        // this.login();
                        userservice.resetpassword(email.text);
                        setState(() {
                          email.text = "";
                        });

                        AlertBox alertBox =
                            AlertBox("We sent reset link on your mail");
                        return showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alertBox.build(context);
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
