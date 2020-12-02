import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/Prescription.dart';
import 'package:my_xpresspill/models/User.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:photo_view/photo_view.dart';
import 'package:get/get.dart';
import "package:my_xpresspill/pages/screens/userorders.dart";

TextStyle defaultStyle() {
  return TextStyle(
    fontFamily: primaryFontFamily,
  );
}

class PrescriptionResult extends StatefulWidget {
  final Prescription prescription;
  final String currentUserId;

  PrescriptionResult(this.prescription, this.currentUserId);

  @override
  _PrescriptionResultState createState() =>
      _PrescriptionResultState(this.prescription, this.currentUserId);
}

class _PrescriptionResultState extends State<PrescriptionResult> {
  final Prescription prescription;
  final String currentUserId;
  _PrescriptionResultState(this.prescription, this.currentUserId);
  MyUser user;

  @override
  void initState() {
    _getUserDetails(prescription.userId);
    // _getCurrentUserId();
    super.initState();
  }

  //we will call the functions for get the user details...
  void _getUserDetails(userId) async {
    DocumentSnapshot doc = await userRef.doc(userId).get();
    setState(() {
      user = MyUser.fromDocument(doc);
      print("-------------------------------${user.firstName}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 400,
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                  onTap: () {
                    print("Profile");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Userdocuments(userid: user.id)));
                  },
                  child: CircleAvatar(
                      backgroundColor: primaryColor,
                      child: Icon(Icons.person, color: Colors.white))),
              title: user != null
                  ? Text(
                      "${user.firstName} ${user.lastName}",
                      style: defaultStyle(),
                    )
                  : Text(""),
              subtitle: user != null
                  ? Text(
                      "${user.contactNumber}",
                      style: defaultStyle(),
                    )
                  : Text(""),
              trailing: IconButton(
                  icon: prescription.isLocked
                      ? Icon(
                          AntDesign.lock,
                          color: greenColor,
                        )
                      : Icon(
                          AntDesign.unlock,
                          color: redColor,
                        )),
              onTap: prescription.isLocked
                  ? null
                  : () {
                      print("here------------");
                      if (currentUserId != null) {
                        prescriptionsRef
                            .doc(prescription.prescriptionId)
                            .update({
                          "isLocked": true,
                          "lockedBy": currentUserId
                        }).then((value) {
                          setState(() {});
                        });
                      }
                    },
            ),
            Container(
              height: 200,
              child: PhotoView(
                imageProvider: NetworkImage("${prescription.prescriptionUrl}"),
              ),
            ),
            prescription.isLocked
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            prescription.isEntered
                                ? AntDesign.check
                                : Icons.clear,
                            color:
                                prescription.isEntered ? greenColor : redColor,
                          ),
                          onPressed: !prescription.isEntered
                              ? () {
                                  prescriptionsRef
                                      .doc(prescription.prescriptionId)
                                      .update({"isEntered": true}).then(
                                          (value) {
                                    setState(() {
                                      this.prescription.isEntered = true;
                                    });
                                  });
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            prescription.isDispatched
                                ? Icons.check
                                : Icons.clear,
                            color: prescription.isDispatched
                                ? greenColor
                                : redColor,
                          ),
                          onPressed: (prescription.isEntered &&
                                  !prescription.isDispatched)
                              ? () {
                                  prescriptionsRef
                                      .doc(prescription.prescriptionId)
                                      .update({"isDispatched": true}).then(
                                          (value) {
                                    setState(() {
                                      this.prescription.isDispatched = true;
                                    });
                                  });
                                }
                              : null,
                        ),
                        IconButton(
                          icon: Icon(
                            prescription.isDelivered
                                ? Icons.check
                                : Icons.clear,
                            color: prescription.isDelivered
                                ? greenColor
                                : redColor,
                          ),
                          onPressed: (prescription.isDispatched &&
                                  !prescription.isDelivered)
                              ? () {
                                  prescriptionsRef
                                      .doc(prescription.prescriptionId)
                                      .update({"isDelivered": true}).then(
                                          (value) {
                                    setState(() {
                                      this.prescription.isDelivered = true;
                                    });
                                  });
                                }
                              : null,
                        )
                      ],
                    ),
                  )
                : Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(Productorders(userid: prescription.userId));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 38.0, bottom: 10, left: 30),
                        child: Text(
                          "Order",
                          style: TextStyle(
                              fontSize: 20,
                              fontFamily: primaryFontFamily,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ),
                    ),
                  ]),
            prescription.isLocked
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Entered",
                          style: defaultStyle(),
                        ),
                        Text(
                          "Dispatched",
                          style: defaultStyle(),
                        ),
                        Text(
                          "Delivered",
                          style: defaultStyle(),
                        ),
                      ],
                    ),
                  )
                : Text("")
          ],
        ),
      ),
    );
  }
}

class Userdocuments extends StatefulWidget {
  String userid;
  Userdocuments({@required this.userid});

  @override
  _UserdocumentsState createState() => _UserdocumentsState();
}

class _UserdocumentsState extends State<Userdocuments> {
  MyUser user;

  @override
  void initState() {
    print("userid");
    _getUserDetails(widget.userid);
    print(widget.userid);

    super.initState();
  }

  //we will call the functions for get the user details...
  void _getUserDetails(userId) async {
    DocumentSnapshot doc = await userRef.doc(userId).get();
    setState(() {
      user = MyUser.fromDocument(doc);
      try {
        // print("-------------------------------${user.healthcard}");
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Documents"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: StreamBuilder(
                stream: userRef.doc(widget.userid).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(primaryColor2),
                    );
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
                                child:
                                    // Image(
                                    //     image: NetworkImage(healthcard),
                                    //     fit: BoxFit.fill),
                                    Image.network(
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
                                child: Text("user did not Upload Health card",
                                    style: defaultStyle())),
                          ]),
                    Insurance != ""
                        ? Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 220.0,
                                width: MediaQuery.of(context).size.width,
                                child:
                                    // Image(
                                    //   image: NetworkImage(Insurance),
                                    //   fit: BoxFit.fill,
                                    // ),
                                    Image.network(
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
                                    "User did not Upload Insurance card",
                                    style: defaultStyle())),
                          ]),
                  ]);
                })),
      ),
    );
  }
}
