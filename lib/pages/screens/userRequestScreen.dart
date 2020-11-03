import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/TransferRequest.dart';
import 'package:shared_preferences/shared_preferences.dart';


TextStyle defaultStyle()
{
  return TextStyle(
    fontFamily: primaryFontFamily,
  );
}

class UserRequestScreen extends StatefulWidget {
  @override
  _UserRequestScreenState createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends State<UserRequestScreen> {
  
  Future<QuerySnapshot> allRequests;
  String _userId;
  SharedPreferences preferences;



  _getUserIdAndRequests()async
  {
    preferences=await SharedPreferences.getInstance();
    setState(() {
      _userId=preferences.getString("userId");

    });
    print(_userId);
    Future<QuerySnapshot> requests=Firestore.instance.collection("prescriptionTransfers").where("userId",isEqualTo: _userId).getDocuments();
    setState(() {
      allRequests=requests;
    });
    
  }
  @override
  void initState() {
    _getUserIdAndRequests();
    super.initState();
  }

  FutureBuilder buildRequestResults()
  {
    return FutureBuilder(
      future: allRequests,
      builder: (context,snapshot){
        if(!snapshot.hasData)
        {
          return Center(child: CircularProgressIndicator());
        }
        List<TransferRequestResult> requestResults=[];
        snapshot.data.documents.forEach((doc){
          TransferRequest request=TransferRequest.fromDocument(doc);
          TransferRequestResult searchResult=TransferRequestResult(request);
          print(request.pharmacyName);
          requestResults.add(searchResult);
        });
        return ListView(
          children: requestResults,
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests",style: defaultStyle(),),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: allRequests==null?Container(
        child: Center(child: Text("No Requests",style: defaultStyle(),),),
      ):buildRequestResults(),
    );


  }
}


class TransferRequestResult extends StatefulWidget {
  final TransferRequest request;
  TransferRequestResult(this.request);

  @override
  _TransferRequestResultState createState() => _TransferRequestResultState(this.request);
}

class _TransferRequestResultState extends State<TransferRequestResult> {
  final TransferRequest request;
  _TransferRequestResultState(this.request);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Transfer from : ${request.pharmacyName}",style: defaultStyle(),),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Status : "),
                  Text(request.isCompleted?"Completed":"Pending",style: defaultStyle(),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

