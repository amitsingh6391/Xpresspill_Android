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
        userservice.resetpassword();
        // AlertBox(
        //     "We sent reset link on your mail id please reset you password ");
        AlertBox alertBox = AlertBox("We sent reset link on your mail");
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return alertBox.build(context);
            });
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
