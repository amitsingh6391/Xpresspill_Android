import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/widgets/drawer.dart';


TextStyle defaultStyle()
{
  return TextStyle(
      fontFamily: primaryFontFamily,
  );
}

class PrescriptionsSettings extends StatefulWidget {
  @override
  _PrescriptionsSettingsState createState() => _PrescriptionsSettingsState();
}

class _PrescriptionsSettingsState extends State<PrescriptionsSettings> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings",style: defaultStyle(),),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Container(
        child:ListView(
          children: [
//            Container(
//              height: 200,
////              child: PinchZoomImage(
////                image: Image.network('https://i.imgur.com/tKg0XEb.jpg'),
////                zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
////                onZoomStart: () {
////                  print('Zoom started');
////                },
////                onZoomEnd: () {
////                  print('Zoom finished');
////                },
////
////              ),
//            child: Text("Settings Page"),
//            ),
          ListTile(
            leading: Icon(AntDesign.bars),
            title: Text("My Prescriptions",style: defaultStyle(),),
            onTap: (){
              Navigator.of(context).pushNamed('/myprescriptions');
            },
          ),
            ListTile(
              leading: Icon(AntDesign.bars),
              title: Text("My Requests",style: defaultStyle(),),
              onTap: (){
                Navigator.of(context).pushNamed('/lockedrequests');
              },
            ),
          ],
        )
      ),
      drawer:  MyDrawer(),
    );
  }
}
