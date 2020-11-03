import 'package:flutter/material.dart';

import '../constants.dart';


Widget customTextField({String labelText, String hintText,TextEditingController inputController, bool isPassword=false,bool isNumber=false,bool isEmail=false}) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15, bottom: 5),
          child: Text(
            labelText,
            style: TextStyle(
              fontFamily: primaryFontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor2,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 15),
          child: TextFormField(
            obscureText: isPassword,
            controller: inputController,
            keyboardType: isNumber?TextInputType.phone: isEmail?TextInputType.emailAddress:TextInputType.text,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80),
                borderSide:
                const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(80),
                borderSide:
                const BorderSide(color: Colors.transparent, width: 0.0),
              ),
              // disabledBorder: new InputBorder(borderSide: BorderSide.none),
              hintStyle: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              filled: true,
              fillColor: Colors.black12,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 17, vertical: 12),

              hintText: hintText,
            ),
          ),
        ),
      ],
    ),
  );
}