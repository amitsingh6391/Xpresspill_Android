import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';


// AppBar userAppBar({String userName})
// {
//   return AppBar(
//     title: Text("Welcome $userName\n ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"),
//     backgroundColor: primaryColor,
//     actions: [
//       Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: CircleAvatar(),
//       )
//     ],
//   );
// }

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  TopBar({@required this.title, @required this.child, @required this.onPressed, this.onTitleTapped})
      : preferredSize = Size.fromHeight(100.0);

  TextStyle defaultStyle()
  {
    return TextStyle(
        fontFamily: primaryFontFamily,
        fontWeight: FontWeight.bold,
      fontSize: 20.0,
        color: Colors.white
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          //SizedBox(height: 30,),
       Container(
         color: primaryColor,
         height: 100,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Padding(
               padding: const EdgeInsets.all(10.0),
               child: Text("Welcome $title\n ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",style: defaultStyle(),),
             ),
             Padding(
               padding: const EdgeInsets.all(10.0),
               child: CircleAvatar(
                 radius: 25.0,
                 backgroundImage: AssetImage("assets/images/profileicon.png"),
               ),
             ),
           ],
         ),
       )


        ],
      ),
    );
  }
}

