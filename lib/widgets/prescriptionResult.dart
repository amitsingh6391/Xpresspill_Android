import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/Prescription.dart';
import 'package:my_xpresspill/models/User.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:photo_view/photo_view.dart';

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

//  _getCurrentUserId()async
//  {
//    SharedPreferences preferences=await SharedPreferences.getInstance();
//    setState(() {
//      currentUserId=preferences.getString("userId");
//    });
//  }

  void _getUserDetails(userId) async {
    DocumentSnapshot doc = await userRef.document(userId).get();
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
//            Container(
//              height: 200.0,
//              width: MediaQuery.of(context).size.width * 0.8,
//              child: Center(
//                child: AspectRatio(
//                  aspectRatio: 16 / 9,
//                  child: Container(
//                    decoration: BoxDecoration(
//                      image: DecorationImage(
//                        fit: BoxFit.cover,
//                        image: NetworkImage("${prescription.prescriptionUrl}"),
//                      ),
//                    ),
////                    child: Center(
////                      child: PinchZoomImage(
////                        image: Image.network('${prescription.prescriptionUrl}'),
////                        zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
////                        onZoomStart: () {
////                          print('Zoom started');
////                        },
////                        onZoomEnd: () {
////                          print('Zoom finished');
////                        },
////
////                      ),
////                    ),
//                  ),
//                ),
//              ),
//            ),
//            Padding(
//              padding: EdgeInsets.all(10.0),
//              child: Container(
//                height: 200,
//                child: CachedNetworkImage(imageUrl:"${prescription.prescriptionUrl}" ),
//              ),
//            ),
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
                                      .document(prescription.prescriptionId)
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
