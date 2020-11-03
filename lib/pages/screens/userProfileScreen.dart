import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  UserService _userService=new UserService();
  String _name;
  String _email;
  //String _contactNumber;
  TextStyle defaultStyle()
  {
    return TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.w400,
    );
  }

  _getUserDetails()async
  {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState(() {
      _name=preferences.getString("userFirstName")+" "+preferences.getString("userLastName");
       _email=preferences.getString("userEmail");
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
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   actions: [
      //     IconButton(
      //       color: primaryColor,
      //       icon: Icon(AntDesign.logout),
      //       onPressed: ()
      //       {
      //         _userService.logOut(context);
      //       },
      //     )
      //   ],
      // ),
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
                    style: TextStyle(fontWeight: FontWeight.bold,fontFamily: primaryFontFamily),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$_email',
                    style: TextStyle(fontWeight: FontWeight.w700,fontFamily: primaryFontFamily),
                  ),
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(vertical: 16.0),
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(8),
                //           topRight: Radius.circular(8),
                //           bottomLeft: Radius.circular(8),
                //           bottomRight: Radius.circular(8)),
                //       color: Colors.white,
                //       boxShadow: [
                //         BoxShadow(
                //             color: Colors.amberAccent,
                //             blurRadius: 4,
                //             spreadRadius: 1,
                //             offset: Offset(0, 1))
                //       ]),
                //   height: 150,
                //   child: Center(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: <Widget>[
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: <Widget>[
                //             IconButton(
                //               icon: Image.asset('assets/icons/wallet.png'),
                //               // onPressed:()=> Navigator.of(context).push(
                //               //     MaterialPageRoute(
                //               //         builder: (_) => WalletPage())),
                //             ),
                //             Text(
                //               'Wallet',
                //               style: TextStyle(fontWeight: FontWeight.bold),
                //             )
                //           ],
                //         ),
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: <Widget>[
                //             IconButton(
                //               icon: Image.asset('assets/icons/truck.png'),
                //               // onPressed: () => Navigator.of(context).push(
                //               //     MaterialPageRoute(builder: (_) => TrackingPage())),
                //             ),
                //             Text(
                //               'Shipped',
                //               style: TextStyle(fontWeight: FontWeight.bold),
                //             )
                //           ],
                //         ),
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: <Widget>[
                //             IconButton(
                //               icon: Image.asset('assets/icons/card.png'),
                //               // onPressed:()=> Navigator.of(context).push(
                //               //     MaterialPageRoute(
                //               //         builder: (_) => PaymentPage())),
                //             ),
                //             Text(
                //               'Payment',
                //               style: TextStyle(fontWeight: FontWeight.bold),
                //             )
                //           ],
                //         ),
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: <Widget>[
                //             IconButton(
                //               icon: Image.asset('assets/icons/contact_us.png'), onPressed: () {},
                //             ),
                //             Text(
                //               'Support',
                //               style: TextStyle(fontWeight: FontWeight.bold),
                //             )
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListTile(
                      leading: Icon(Icons.exit_to_app),
                    title: Text('Logout',style: defaultStyle(),),
                    //trailing: Icon(AntDesign.logout, color: Colors.yellow),
                    onTap: () => _userService.logOut(context)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: ListTile(
                      leading: Icon(Icons.pending),
                      title: Text('Requests',style: defaultStyle(),),
                      //trailing: Icon(AntDesign.logout, color: Colors.yellow),
                      onTap: (){
                        Navigator.of(context).pushNamed('/userrequestscreen');
                      }
                  ),
                ),
                // ListTile(
                //   title: Text('Settings'),
                //   subtitle: Text('Privacy and logout'),
                //   leading: Image.asset('assets/icons/settings_icon.png', fit: BoxFit.scaleDown, width: 30, height: 30,),
                //   trailing: Icon(Icons.chevron_right, color: Colors.yellow),
                //   // onTap: () => Navigator.of(context).push(
                //   //     MaterialPageRoute(builder: (_) => SettingsPage())),
                // ),
                // Divider(),
                // ListTile(
                //   title: Text('Help & Support'),
                //   subtitle: Text('Help center and legal support'),
                //   leading: Image.asset('assets/icons/support.png'),
                //   trailing: Icon(
                //     Icons.chevron_right,
                //     color: Colors.yellow,
                //   ),
                // ),
                // Divider(),
                // ListTile(
                //   title: Text('FAQ'),
                //   subtitle: Text('Questions and Answer'),
                //   leading: Image.asset('assets/icons/faq.png'),
                //   trailing: Icon(Icons.chevron_right, color: Colors.yellow),
                //   // onTap: () => Navigator.of(context).push(
                //   //     MaterialPageRoute(builder: (_) => FaqPage())
                //   // ),
                // ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
