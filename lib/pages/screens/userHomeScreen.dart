import 'package:flutter/material.dart';
import 'package:my_xpresspill/widgets/drawer.dart';
import 'package:my_xpresspill/widgets/homeScreenCart.dart';
import 'package:my_xpresspill/widgets/userAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {

  String _name;
  // String _email;
  // String _contactNumber;

  _getUserDetails()async
  {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState(() {
      _name=preferences.getString("userFirstName");

          // +" "+preferences.getString("userLastName");
      // _email=preferences.getString("userEmail");
      // _contactNumber=preferences.getString("userContactNumber");
    });
  }

  @override
  void initState() {
    _getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: TopBar(title: _name,),
      body: GridView.count(
        crossAxisCount: 2,
        children: [

          homeScreenCard(
              context: context,
              imgSrc: "assets/images/icon5.svg",
              cardText: "Transfer your refills",
              color: Colors.white,

              onTap: ()
              {
                Navigator.of(context).pushNamed('/transferprescription');
              }

          ),
          homeScreenCard(
              context: context,
              imgSrc: "assets/images/icon4.svg",
              cardText: "Upload a prescription",
              color: Colors.white,
              onTap: ()
              {
                Navigator.of(context).pushNamed('/addprescription');
              }

          ),
          homeScreenCard(
              context: context,
              imgSrc: "assets/images/icon6.svg",
              cardText: "Talk to a doctor",
              color: Colors.white,
              onTap: ()
              {
                print("talk to doctor");
              }

          ),
          homeScreenCard(
              context: context,
              imgSrc: "assets/images/icon3.svg",
              cardText: "E-commerce",
              color: Colors.white,
              onTap: ()
              {
                Navigator.of(context).pushNamed('/ecommerce');
              }
          ),

        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: (){
      //     Navigator.of(context).pushNamed('/addprescription');
      //   },
      // ),

      drawer: MyDrawer(),
    );
  }
}

