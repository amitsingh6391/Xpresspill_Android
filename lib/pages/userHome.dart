
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

  //  _onTransferPressed()
  // {
  //   print("Transfer Pressed");
  // }
  // _onUploadPressed()
  // {
  //   print("Upload Pressed");
  // }
  // _onTalkDoctorPressed()
  // {
  //   print("Doctor Pressed");
  // }
  // _onEcommercePressed()
  // {
  //   print("E-commerce Pressed");
  // }



  Scaffold buildUserScreen(){
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
            title: Text('Home',
              style: TextStyle(
                  fontFamily: primaryFontFamily
              ),
            ),
            icon: Icon(AntDesign.home),
          ),
          BottomNavyBarItem(
              activeColor: white,
              inactiveColor: white,
              title: Text('Notifications',
                style: TextStyle(
                    fontFamily: primaryFontFamily
                ),
              ),
              icon: Icon(AntDesign.notification)
          ),
          BottomNavyBarItem(
              activeColor: white,
              inactiveColor: white,
              title: Text('Profile',
                style: TextStyle(
                    fontFamily: primaryFontFamily
                ),
              ),
              icon: Icon(AntDesign.profile)
          ),


        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return buildUserScreen();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       actions: [
  //         Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: CircleAvatar(),
  //         )
  //       ],
  //     ),
  //     body: GridView.count(
  //       crossAxisCount: 2,
  //       children: [
  //
  //         homeScreenCard(
  //             context: context,
  //             imgSrc: "assets/images/icon5.svg",
  //             cardText: "Transfer your refills",
  //             color: Colors.white,
  //
  //             onTap: ()
  //             {
  //               print("transfer your refills");
  //             }
  //
  //         ),
  //         homeScreenCard(
  //             context: context,
  //             imgSrc: "assets/images/icon4.svg",
  //             cardText: "Upload a prescription",
  //             color: Colors.white,
  //             onTap: ()
  //             {
  //               Navigator.of(context).pushNamed('/addprescription');
  //             }
  //
  //         ),
  //         homeScreenCard(
  //             context: context,
  //             imgSrc: "assets/images/icon6.svg",
  //             cardText: "Talk to a doctor",
  //             color: Colors.white,
  //             onTap: ()
  //             {
  //               print("talk to doctor");
  //             }
  //
  //         ),
  //         homeScreenCard(
  //             context: context,
  //             imgSrc: "assets/images/icon3.svg",
  //             cardText: "E-commerce",
  //             color: Colors.white,
  //             onTap: ()
  //             {
  //               print("ecommerce");
  //             }
  //         ),
  //
  //       ],
  //     ),
  //     // floatingActionButton: FloatingActionButton(
  //     //   child: Icon(Icons.add),
  //     //   onPressed: (){
  //     //     Navigator.of(context).pushNamed('/addprescription');
  //     //   },
  //     // ),
  //
  //     drawer: MyDrawer(),
  //   );
  // }
}