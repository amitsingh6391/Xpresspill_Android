import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/widgets/defaultTextStyleTheme.dart';

class UserCartScreen extends StatefulWidget {
  @override
  _UserCartScreenState createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Your Cart",style: defaultStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
