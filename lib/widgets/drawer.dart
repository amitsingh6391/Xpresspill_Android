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
  UserService _userService=new UserService();

  _getUserDetails()async
  {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState(() {
      _name=preferences.getString("userFirstName")+" "+preferences.getString("userLastName");
      _email=preferences.getString("userEmail");
      _contactNumber=preferences.getString("userContactNumber");
    });
  }

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  TextStyle defaultStyle()
  {
    return TextStyle(
      fontFamily: primaryFontFamily,
      fontWeight: FontWeight.bold
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(),
          ListTile(
            title: Text("$_name",style: defaultStyle(),),
          ),
          ListTile(
            title: Text("$_email",style: defaultStyle(),),
          ),
          ListTile(
            title: Text("$_contactNumber",style: defaultStyle(),),
          ),
          ListTile(
            title: Text("Logout",style: defaultStyle(),),
            onTap: (){
              _userService.logOut(context);
            },
          )
        ],
      ),
    );
  }
}



//
//Widget userDetailsDrawer({BuildContext context})
//{
//
//  return Drawer(
//    child: ListView(
//      padding: EdgeInsets.zero,
//      children: <Widget>[
//        DrawerHeader(
//          decoration: BoxDecoration(
//              color: primaryColor
//          ),
//          padding: EdgeInsets.all(10.0),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.symmetric(vertical: 5.0),
//                    child:Text("${user.displayName}",
//                      style: TextStyle(
//                        fontSize:25.0,
//                      ),
//                    ),
//                  ),
//                  IconButton(icon: Icon(AntDesign.edit),alignment: Alignment.topRight,),
//                ],
//              ),
//              Padding(
//                padding: EdgeInsets.symmetric(vertical:5.0),
//                child: Text("${user.email}",
//                  style: TextStyle(
//                    fontSize:15.0,
//                  ),
//                ),
//              ),
//
//            ],
//          ),
//
//        ),
//        ListTile(
//          onTap:(){
//
//          },
//          title: Text("Logout"),
//        ),
//      ],
//    ),
//  );
//}