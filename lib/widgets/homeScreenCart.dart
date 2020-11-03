import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_xpresspill/constants.dart';

TextStyle defaultStyle()
{
  return TextStyle(
      fontFamily: primaryFontFamily,
      fontWeight: FontWeight.bold,
      fontSize: 15.0
  );
}

Container homeScreenCard({context,String imgSrc,String cardText,Color color=Colors.white,onTap()})
{
 return Container(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.8,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
            color: color,
            child: Column(
              children: [
                SvgPicture.asset(imgSrc, height: 100.0),
                Text(cardText,style: defaultStyle(),)
              ],
            ),

        ),
      )
  );
}