import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_xpresspill/constants.dart';

class Loader{
  static Future<void> showLoadingScreen(BuildContext context, GlobalKey key) async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new WillPopScope(
          onWillPop: () async => false,
          child: Container(
            key: key,
            child: SpinKitFoldingCube(
              color: primaryColor2,
              size: 50.0,
            ),
          )
        );
      }
    );
  }
}