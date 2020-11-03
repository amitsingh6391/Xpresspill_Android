import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';

Container circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 10.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(primaryColor2),

    ),
  );
}

Container linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      valueColor:AlwaysStoppedAnimation(primaryColor2),
    ),
  );
}
