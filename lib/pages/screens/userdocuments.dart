import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/widgets/progress-indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import "package:my_xpresspill/Widgets/defaultTextStyleTheme.dart";
import 'package:cached_network_image/cached_network_image.dart';

class Userdocuments extends StatefulWidget {
  @override
  _UserdocumentsState createState() => _UserdocumentsState();
}

class _UserdocumentsState extends State<Userdocuments> {
  String userId;
  bool isUploading = false;
  Future<QuerySnapshot> userdocuments;

  @override
  void initState() {
    super.initState();
    getcurrentuserid();
  }

  getcurrentuserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userId = preferences.getString("userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Your Documents",
              style: TextStyle(fontSize: 20, color: Colors.white)),
          backgroundColor: primaryColor),
      body: SingleChildScrollView(
        child: Container(
            child: StreamBuilder(
                stream: userRef.doc(userId).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return circularProgress();
                  }

                  var Profiledetail = snapshot.data;
                  String healthcard = Profiledetail["Healthcard"];
                  String Insurance = Profiledetail["Insurance"];
                  print(healthcard);
                  print(Insurance);

                  return Column(children: [
                    SizedBox(height: 50),
                    healthcard != ""
                        ? Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 220.0,
                                width: MediaQuery.of(context).size.width,
                                // child: CachedNetworkImage(
                                //     imageUrl: healthcard, fit: BoxFit.cover),

                                child: Image.network(
                                  healthcard,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child:
                                    Text("HealthCard", style: defaultStyle()))
                          ])
                        : Column(children: [
                            Center(
                                child: Text(
                                    "You did not Upload your Health card",
                                    style: defaultStyle())),
                          ]),
                    Insurance != ""
                        ? Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 220.0,
                                width: MediaQuery.of(context).size.width,
                                // child: CachedNetworkImage(
                                //     imageUrl: Insurance, fit: BoxFit.cover),

                                child: Image.network(
                                  Insurance,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text("Insurance", style: defaultStyle()))
                          ])
                        : Column(children: [
                            Center(
                                child: Text(
                                    "You did not Upload your Insurance ",
                                    style: defaultStyle())),
                          ]),
                  ]);
                })),
      ),
    );
  }
}
