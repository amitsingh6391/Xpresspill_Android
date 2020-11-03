import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/pages/screens/manageProducts.dart';
import 'package:my_xpresspill/pages/screens/manageUsers.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userRef = FirebaseFirestore.instance.collection('users');
final productsRef = FirebaseFirestore.instance.collection('products');
final prescriptionsRef = FirebaseFirestore.instance.collection('prescriptions');
final prescriptionTransfersRef =
    FirebaseFirestore.instance.collection("prescriptionTransfers");


final StorageReference storageRef = FirebaseStorage.instance.ref();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  PageController _pageController;
  Future<QuerySnapshot> allUsers;
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

  TextStyle defaultStyle() {
    return TextStyle(
      fontFamily: primaryFontFamily,
    );
  }

  Scaffold buildAdminScreen() {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            ProductsScreen(),
            ManageUsersScreen(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed('/addproduct');
        },
        label: Text(
          'Add Product',
          style: defaultStyle(),
        ),
        icon: Icon(Icons.add),
        backgroundColor: primaryColor,
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
              'Products',
              style: TextStyle(fontFamily: primaryFontFamily),
            ),
            icon: Icon(AntDesign.profile),
          ),
          BottomNavyBarItem(
              activeColor: white,
              inactiveColor: white,
              title: Text(
                'Users',
                style: TextStyle(fontFamily: primaryFontFamily),
              ),
              icon: Icon(AntDesign.addusergroup)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildAdminScreen();
  }
}
