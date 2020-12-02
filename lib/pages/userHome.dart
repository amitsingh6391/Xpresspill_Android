import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/pages/screens/userHomeScreen.dart';
import 'package:my_xpresspill/pages/screens/userNotificationsScreen.dart';
import 'package:my_xpresspill/pages/screens/userProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  SharedPreferences sharedPreferences;
  int _currentIndex = 0;
  PageController _pageController;

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

  Scaffold buildUserScreen() {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            UserHomeScreen(),
            UserNotificationScreen(),
            UserProfileScreen()
          ],
        ),
      ),
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
            title: Text(
              'Home',
              style: TextStyle(fontFamily: primaryFontFamily),
            ),
            icon: Icon(AntDesign.home),
          ),
          BottomNavyBarItem(
              activeColor: white,
              inactiveColor: white,
              title: Text(
                'Notifications',
                style: TextStyle(fontFamily: primaryFontFamily),
              ),
              icon: Icon(AntDesign.notification)),
          BottomNavyBarItem(
              activeColor: white,
              inactiveColor: white,
              title: Text(
                'Profile',
                style: TextStyle(fontFamily: primaryFontFamily),
              ),
              icon: Icon(AntDesign.profile)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUserScreen();
  }
}
