import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/Prescription.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/services/userService.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_xpresspill/models/User.dart';

import 'package:photo_view/photo_view.dart';

class Userprescription extends StatefulWidget {
  @override
  _UserprescriptionState createState() => _UserprescriptionState();
}

class _UserprescriptionState extends State<Userprescription> {
  Stream<QuerySnapshot> _allPrescriptions;
  UserService _userService = new UserService();
  String currentUserId;

  @override
  void initState() {
    _getCurrentUserId();

    super.initState();
  }

  _getCurrentUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = preferences.getString("userId");
    });
    print(currentUserId);
    var prescriptions =
        prescriptionsRef.where("userId", isEqualTo: currentUserId).snapshots();
    setState(() {
      _allPrescriptions = prescriptions;
    });
  }

  StreamBuilder buildPrescriptionResults() {
    return StreamBuilder(
      stream: _allPrescriptions,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              Prescription prescription =
                  Prescription.fromDocument(snapshot.data.documents[index]);
              return Prescriptiontile(prescription, currentUserId);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Prescriptions"),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(AntDesign.logout),
            onPressed: () {
              _userService.logOut(context);
            },
          )
        ],
      ),
      body: _allPrescriptions == null
          ? Center(child: CircularProgressIndicator())
          : buildPrescriptionResults(),
      // drawer: userDetailsDrawer(context: context),
    );
  }
}

//user precription will be shown in this prescriptiontile class

TextStyle defaultStyle() {
  return TextStyle(
    fontFamily: primaryFontFamily,
  );
}

class Prescriptiontile extends StatefulWidget {
  final Prescription prescription;
  final String currentUserId;

  Prescriptiontile(this.prescription, this.currentUserId);

  @override
  _PrescriptiontileState createState() =>
      _PrescriptiontileState(this.prescription, this.currentUserId);
}

class _PrescriptiontileState extends State<Prescriptiontile> {
  final Prescription prescription;
  final String currentUserId;
  _PrescriptiontileState(this.prescription, this.currentUserId);
  MyUser user;

  @override
  void initState() {
    _getUserDetails(prescription.userId);

    super.initState();
  }

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
              //leading: prescription.isLocked?Icon(AntDesign.lock):Icon(AntDesign.unlock),
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
                        // prescriptionsRef
                        //     .doc(prescription.prescriptionId)
                        //     .update({
                        //   "isLocked": true,
                        //   "lockedBy": currentUserId
                        // }).then((value) {
                        //   setState(() {});
                        // });
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
                                  // prescriptionsRef
                                  //     .doc(prescription.prescriptionId)
                                  //     .update({"isEntered": true}).then(
                                  //         (value) {
                                  //   setState(() {
                                  //     this.prescription.isEntered = true;
                                  //   });
                                  // });
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
                                  // prescriptionsRef
                                  //     .doc(prescription.prescriptionId)
                                  //     .update({"isDispatched": true}).then(
                                  //         (value) {
                                  //   setState(() {
                                  //     this.prescription.isDispatched = true;
                                  //   });
                                  // });
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
                                  // prescriptionsRef
                                  //     .doc(prescription.prescriptionId)
                                  //     .update({"isDelivered": true}).then(
                                  //         (value) {
                                  //   setState(() {
                                  //     this.prescription.isDelivered = true;
                                  //   });
                                  // });
                                }
                              : null,
                        )
                      ],
                    ),
                  )
                : Text(""),
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
