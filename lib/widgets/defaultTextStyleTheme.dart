import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';

TextStyle defaultStyle({FontWeight weight=FontWeight.normal,Color color=Colors.black})
{
  return TextStyle(
      fontFamily: primaryFontFamily,
      fontWeight: weight,
      color: color
  );
}