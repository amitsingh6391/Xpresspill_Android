import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Start extends StatelessWidget {
  final UserService _userService = new UserService();
  SharedPreferences sharedPreferences;
  validateToken(context) async {
    final storage = new FlutterSecureStorage();
    sharedPreferences = await SharedPreferences.getInstance();
    // bool isAdmin=sharedPreferences.getBool("isAdmin");
    // bool isPharmacist=sharedPreferences.getBool("isPharmacist");

    //   print("isAdmin---------- $isAdmin");
    // print("isPharmacist---------- $isPharmacist");

    String role = sharedPreferences.getString("role");
    String value = await storage.read(key: 'token');
    if (value != null) {
      String decodedToken = _userService.validateToken(value);
      if (decodedToken != null) {
        if (role == 'admin') {
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (role == 'pharmacist') {
          Navigator.of(context).pushReplacementNamed('/pharmacisthome');
        } else if (role != 'admin' && role != 'pharmacist') {
          Navigator.of(context).pushReplacementNamed('/userhome');
        }
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            SvgPicture.asset('assets/images/7.svg', height: 300.0),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
              child: ButtonTheme(
                minWidth: 220.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36)),
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  color: primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    'Login',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    validateToken(context);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
              child: ButtonTheme(
                minWidth: 220.0,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36),
                      side: BorderSide(color: primaryColor2)),
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  color: primaryColor2,
                  textColor: Colors.white,
                  child: Text(
                    'Sign Up',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
