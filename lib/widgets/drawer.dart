import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _name;
  String _email;
  String _contactNumber;
  UserService _userService = new UserService();

  _getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _name = preferences.getString("userFirstName") +
          " " +
          preferences.getString("userLastName");
      _email = preferences.getString("userEmail");
      _contactNumber = preferences.getString("userContactNumber");
    });
  }

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  TextStyle defaultStyle() {
    return TextStyle(
        fontFamily: primaryFontFamily, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Center(
                child: Column(children: [
              Image(
                  image: AssetImage("assets/images/appicon.png"),
                  height: 100,
                  width: size.width * 1),
              Text("Easiest Way To Manage Your Medications",
                  style: TextStyle(color: primaryColor)),
            ])),
            decoration: BoxDecoration(),
          ),
          ListTile(
            title: Text(
              "$_name",
              style: defaultStyle(),
            ),
          ),
          ListTile(
            title: Text(
              "$_email",
              style: defaultStyle(),
            ),
          ),
          ListTile(
            title: Text(
              "$_contactNumber",
              style: defaultStyle(),
            ),
          ),
          ListTile(
            title: Text(
              "Logout",
              style: defaultStyle(),
            ),
            onTap: () {
              _userService.logOut(context);
            },
          )
        ],
      ),
    );
  }
}
