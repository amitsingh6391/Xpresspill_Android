import 'package:flutter/material.dart';

class UserNotificationScreen extends StatefulWidget {
  @override
  _UserNotificationScreenState createState() => _UserNotificationScreenState();
}

class _UserNotificationScreenState extends State<UserNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("Notifications"),),
      ),
    );
  }
}
