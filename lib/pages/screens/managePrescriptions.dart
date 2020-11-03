import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/Prescription.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/widgets/drawer.dart';
import 'package:my_xpresspill/widgets/prescriptionResult.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ManagePrescriptions extends StatefulWidget {
  @override
  _ManagePrescriptionsState createState() => _ManagePrescriptionsState();
}

class _ManagePrescriptionsState extends State<ManagePrescriptions> {
  Stream<QuerySnapshot> allPrescriptions;
  String currentUserId;


  @override
  void initState() {
    _getCurrentUserId();
    var prescriptions=prescriptionsRef.where("isLocked",isEqualTo: false).snapshots();
    setState(() {
      allPrescriptions=prescriptions;
    });
    super.initState();
  }

  _getCurrentUserId()async
  {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState(() {
      currentUserId=preferences.getString("userId");
    });
  }

  StreamBuilder buildPrescriptionResults()
  {
    return StreamBuilder(
      stream: allPrescriptions,
      builder: (context,snapshot){
        if(!snapshot.hasData)
        {
          return Center(child: CircularProgressIndicator());
        }
//        List<PrescriptionResult> searchResults=[];
//        snapshot.data.documents.forEach((doc){
//          Prescription prescription=Prescription.fromDocument(doc);
//          PrescriptionResult searchResult=PrescriptionResult(prescription);
//          searchResults.add(searchResult);
//        });

        return ListView.builder(
            itemCount:snapshot.data.documents.length,
            itemBuilder: (context,index){
              Prescription prescription=Prescription.fromDocument(snapshot.data.documents[index]);
              return  PrescriptionResult(prescription,currentUserId);
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Prescriptions",
        style: TextStyle(
        fontFamily: primaryFontFamily
        ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: allPrescriptions==null?Center(child: CircularProgressIndicator()):buildPrescriptionResults(),
      drawer:MyDrawer(),
    );
  }
}




