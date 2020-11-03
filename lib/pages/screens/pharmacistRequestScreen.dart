import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/TransferRequest.dart';
import 'package:my_xpresspill/models/User.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextStyle defaultStyle({FontWeight weight=FontWeight.normal,Color color=Colors.black})
{
  return TextStyle(
      fontFamily: primaryFontFamily,
      fontWeight: weight,
      color: color
  );
}

class PharmacistRequestScreen extends StatefulWidget {
  @override
  _PharmacistRequestScreenState createState() => _PharmacistRequestScreenState();
}

class _PharmacistRequestScreenState extends State<PharmacistRequestScreen> {

  Stream<QuerySnapshot> allRequests;
  String currentUserId;

  @override
  void initState() {
    _getCurrentUserId();
    var prescriptions=prescriptionTransfersRef.where("isLocked",isEqualTo: false).snapshots();
    setState(() {
      allRequests=prescriptions;
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

  StreamBuilder buildRequestResults()
  {
    return StreamBuilder(
      stream: allRequests,
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
        title: Text("All Requests",style: defaultStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: allRequests==null?Center(child: CircularProgressIndicator()):buildRequestResults(),
      drawer:MyDrawer(),

    );
  }
}

class PharmacistTransferPrescriptionResult extends StatefulWidget {
  final TransferRequest request;
  final String currentUserId;

  PharmacistTransferPrescriptionResult(this.request,this.currentUserId);

  @override
  _PharmacistTransferPrescriptionResultState createState() => _PharmacistTransferPrescriptionResultState(this.request,this.currentUserId);
}

class _PharmacistTransferPrescriptionResultState extends State<PharmacistTransferPrescriptionResult> {
  final TransferRequest request;
  final String currentUserId;
  MyUser user;



  _PharmacistTransferPrescriptionResultState(this.request,this.currentUserId);


  @override
  void initState() {
    _getUserDetails(request.userId);
    super.initState();
  }

  void _getUserDetails(userId) async{
    DocumentSnapshot doc=await userRef.document(userId).get();
    setState(() {
      user=MyUser.fromDocument(doc);
      print("-------------------------------${user.firstName}");

    });
  }

  _lockRequest()
  {
    prescriptionTransfersRef.document(request.requestId).updateData({
      'isLocked':true,
      'lockedBy':currentUserId
    });
    setState(() {

    });
  }

  _completeRequest()
  {
    prescriptionTransfersRef.document(request.requestId).updateData({
      'isCompleted':true
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              tileColor: primaryColor3,
              trailing: IconButton( icon: request.isLocked?Icon(AntDesign.lock,color: greenColor ,):Icon(AntDesign.unlock,color: redColor,),
              onPressed:request.isLocked ?null:()
                {
                  _lockRequest();
                  setState(() {
                    request.isLocked=true;
                  });
                },
              ),
              title: user!=null?Text("${user.firstName} ${user.lastName}",style: defaultStyle(weight: FontWeight.bold),):Text(""),
              subtitle: user!=null?Text("${user.contactNumber}",style: defaultStyle(),):Text(""),
            ),
            Text("Pharmacy Details :",style: defaultStyle(weight: FontWeight.bold,color: primaryColor2),),
            Text("Name : ${request.pharmacyName}",style: defaultStyle(),),
            Text("Address : ${request.pharmacyAddress}",style: defaultStyle(),),
            Text("Zip Code : ${request.pharmacyZipCode}",style: defaultStyle(),),
            Text("Phone : ${request.pharmacyContactNumber}",style: defaultStyle(),),
            request.isLocked?Text("Status : ${!request.isCompleted?"Pending":"Completed"}",style: defaultStyle(),):Text(""),

            request.isLocked?ListTile(
              trailing: RaisedButton(
                color: greenColor,
                textColor: Colors.white,
                child: Text("Mark as Completed",style: defaultStyle(color: Colors.white),),
                onPressed: request.isCompleted?null:()
                {
                  _completeRequest();
                  setState(() {
                    request.isCompleted=true;
                  });
                },
              )
            ):Text("")

          ],
        )
      )
    );
  }
}

