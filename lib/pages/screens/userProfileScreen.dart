import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';

import 'package:my_xpresspill/pages/screens/completeprofile.dart';
import 'package:my_xpresspill/pages/screens/userprescription.dart';
import 'package:my_xpresspill/pages/screens/userdocuments.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserService _userService = new UserService();
  String _name;
  String _email;
  //String _contactNumber;
  TextStyle defaultStyle() {
    return TextStyle(
      fontFamily: primaryFontFamily,
      fontWeight: FontWeight.w400,
    );
  }

  _getUserDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _name = preferences.getString("userFirstName") +
          " " +
          preferences.getString("userLastName");
      _email = preferences.getString("userEmail");
      // _contactNumber=preferences.getString("userContactNumber");
    });
  }

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Complete Your Profile",
            style: TextStyle(fontFamily: primaryFontFamily),
          ),
          children: <Widget>[
            SimpleDialogOption(
                child: Text(
                  "Add your Health Card",
                  style: TextStyle(fontFamily: primaryFontFamily),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Addhealthcard()));
                }),
            SimpleDialogOption(
                child: Text(
                  "Add your Insurance",
                  style: TextStyle(fontFamily: primaryFontFamily),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddInsurance()));
                }),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(fontFamily: primaryFontFamily),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.only(left: 16.0, right: 16.0, top: kToolbarHeight),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  maxRadius: 48,
                  backgroundImage: AssetImage("assets/images/profileicon.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$_name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: primaryFontFamily),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$_email',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFamily: primaryFontFamily),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListTile(
                      leading: Icon(Icons.pending),
                      title: Text(
                        'Requests',
                        style: defaultStyle(),
                      ),
                      //trailing: Icon(AntDesign.logout, color: Colors.yellow),
                      onTap: () {
                        Navigator.of(context).pushNamed('/userrequestscreen');
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListTile(
                      leading: Icon(Icons.book),
                      title: Text(
                        'My Prescription',
                        style: defaultStyle(),
                      ),
                      //trailing: Icon(AntDesign.logout, color: Colors.yellow),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Userprescription()));
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListTile(
                      leading: Icon(Icons.notes),
                      title: Text(
                        'My Documents',
                        style: defaultStyle(),
                      ),
                      //trailing: Icon(AntDesign.logout, color: Colors.yellow),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Userdocuments()));
                      }),
                ),
                ListTile(
                  title: Text('Complete Profile'),
                  //subtitle: Text('Upload health Card '),
                  leading: Icon(Icons.note_add),
                  trailing: Icon(Icons.chevron_right, color: Colors.yellow),
                  onTap: () {
                    selectImage(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text(
                        'Logout',
                        style: defaultStyle(),
                      ),
                      //trailing: Icon(AntDesign.logout, color: Colors.yellow),
                      onTap: () => _userService.logOut(context)),
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
