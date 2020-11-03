import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/pages/login.dart';
import 'package:my_xpresspill/pages/pharmacistHome.dart';
import 'package:my_xpresspill/pages/screens/addPrescriptionScreen.dart';
import 'package:my_xpresspill/pages/screens/addProductScreen.dart';
import 'package:my_xpresspill/pages/screens/ecommerceScreen.dart';
import 'package:my_xpresspill/pages/screens/myPrescriptions.dart';
import 'package:my_xpresspill/pages/screens/pharmacistLockedRequestScreen.dart';
import 'package:my_xpresspill/pages/screens/pharmacistRequestScreen.dart';
import 'package:my_xpresspill/pages/screens/transferPrescriptionScreen.dart';
import 'package:my_xpresspill/pages/screens/userCartScreen.dart';
import 'package:my_xpresspill/pages/screens/userRequestScreen.dart';
import 'package:my_xpresspill/pages/signup.dart';
import 'package:my_xpresspill/pages/start.dart';
import 'package:my_xpresspill/pages/userHome.dart';
import "dart:async";
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

bool firstTime = false;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   //SharedPreferences prefs = await SharedPreferences.getInstance();
//   // runApp(
//   //   DevicePreview(
//   //     builder: (context) => MyApp(),
//   //   ),
//   // );
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //FirebaseAdMob.instance.initialize(appId: AdMobService().getAdMobAppId());
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Start(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/signup': (context) => Signup(),
        '/addproduct': (context) => AddProductScreen(),
        '/pharmacisthome': (context) => PharmacistHome(),
        '/userhome': (context) => UserHome(),
        '/addprescription': (context) => AddPrescriptionScreen(),
        '/myprescriptions': (context) => MyPrescriptions(),
        '/lockedrequests': (context) => PharmacistLockedRequestScreen(),
        '/ecommerce': (context) => EcommerceScreen(),
        '/transferprescription': (context) => TransferPrescriptionScreen(),
        '/userrequestscreen': (context) => UserRequestScreen(),
        '/pharmacistrequestscreen': (context) => PharmacistRequestScreen(),
        '/usercart': (context) => UserCartScreen()
      },
      theme: ThemeData(
          bottomSheetTheme:
              BottomSheetThemeData(backgroundColor: Colors.white)),
    );
  }
}
