import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/widgets/defaultTextStyleTheme.dart';

class Paymentscreen extends StatefulWidget {
  @override
  _PaymentscreenState createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

     appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Payment-Page",
          style: defaultStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body:Container(
        child:Center(
          child:Text("Under processing......")
        )
      )
      
    );
  }
}