import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/pages/screens/managePrescriptions.dart';
import 'package:my_xpresspill/pages/screens/pharmacistRequestScreen.dart';
import 'package:my_xpresspill/pages/screens/prescriptionsSettings.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PharmacistHome extends StatefulWidget {
  @override
  _PharmacistHomeState createState() => _PharmacistHomeState();
}

class _PharmacistHomeState extends State<PharmacistHome> {
  int _currentIndex = 0;
  PageController _pageController;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Scaffold buildAdminScreen(){
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            ManagePrescriptions(),
            PharmacistRequestScreen(),
            PrescriptionsSettings(),


          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: () {
//          Navigator.of(context).pushNamed('/addproduct');
//        },
//        label: Text('Add Product'),
//        icon: Icon(Icons.add),
//        backgroundColor: primaryColor,
//
//      ),
      bottomNavigationBar: BottomNavyBar(
        backgroundColor: primaryColor,
        containerHeight: 60.0,
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            activeColor: white,
            inactiveColor: white,
            title: Text('Prescriptions',
              style: TextStyle(
                  fontFamily: primaryFontFamily
              ),
            ),
            icon: Icon(AntDesign.profile),
          ),
          BottomNavyBarItem(
            activeColor: white,
            inactiveColor: white,
            title: Text('Requests',
              style: TextStyle(
                  fontFamily: primaryFontFamily
              ),
            ),
            icon: Icon(AntDesign.checkcircle),
          ),
          BottomNavyBarItem(
              activeColor: white,
              inactiveColor: white,
              title: Text('Settings',
                style: TextStyle(
                    fontFamily: primaryFontFamily
                ),
              ),
              icon: Icon(AntDesign.setting)
          ),


        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return buildAdminScreen();
  }
}

