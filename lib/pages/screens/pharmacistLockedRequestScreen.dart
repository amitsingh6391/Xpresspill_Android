import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/TransferRequest.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/pages/screens/pharmacistRequestScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PharmacistLockedRequestScreen extends StatefulWidget {
  @override
  _PharmacistLockedRequestScreenState createState() => _PharmacistLockedRequestScreenState();
}

class _PharmacistLockedRequestScreenState extends State<PharmacistLockedRequestScreen> {
  Stream<QuerySnapshot> _allMyRequests;
  String currentUserId;

  TextStyle defaultStyle()
  {
    return TextStyle(
        fontFamily: primaryFontFamily,
    );
  }

  _getCurrentUserIdAndRequests()async
  {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    setState(() {
      currentUserId=preferences.getString("userId");
    });
    print(currentUserId);
    var requests=prescriptionTransfersRef.where("lockedBy",isEqualTo: currentUserId).snapshots();
    setState(() {
      _allMyRequests=requests;
    });
  }
  @override
  void initState() {
    _getCurrentUserIdAndRequests();
    super.initState();
  }

  StreamBuilder buildRequestResults()
  {
    return StreamBuilder(
      stream: _allMyRequests,
      builder: (context,snapshot){
        if(!snapshot.hasData)
        {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
            itemCount:snapshot.data.documents.length,
            itemBuilder: (context,index){
              TransferRequest prescription=TransferRequest.fromDocument(snapshot.data.documents[index]);
              return  PharmacistTransferPrescriptionResult(prescription,currentUserId);
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Manage Requests",style: defaultStyle(),),
        centerTitle: true,
      ),
      body: _allMyRequests==null?Center(child: CircularProgressIndicator()):buildRequestResults(),

    );
  }
}
