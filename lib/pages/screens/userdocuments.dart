import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_xpresspill/widgets/progress-indicator.dart';
import "package:my_xpresspill/Widgets/defaultTextStyleTheme.dart";

class Userdocuments extends StatefulWidget{
  @override
  _UserdocumentsState createState()=>_UserdocumentsState();
}

class _UserdocumentsState extends State<Userdocuments>{

  String userId;
  bool isUploading= false;
  Future<QuerySnapshot> userdocuments;

@override 
void initState(){
  super.initState();
  getcurrentuserid();
}


getcurrentuserid()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState((){
     userId = preferences.getString("userId"); 
  }); 
}


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title:Text("Your Documents",style:TextStyle(fontSize:20,color:Colors.white)),
      backgroundColor:primaryColor),
      body:SingleChildScrollView(child:Container(
        child:StreamBuilder(
          stream:userRef.doc(userId).snapshots(),
          builder:(context,snapshot){
            if (!snapshot.hasData) {
                          return Text("Loading");
                        }

                        var Profiledetail = snapshot.data;
                        String healthcard = Profiledetail["Healthcard"];
                        String licences = Profiledetail["Licencescard"];
                        print(healthcard);
                        print(licences);

                        return Column(

                          children:[

                            SizedBox(height:50),

                            healthcard !="" ?Column(
                              children:[
                                Image(
                              image:NetworkImage(healthcard)
                            ),
                            Padding(

                              padding: EdgeInsets.all(10.0),

                           child: Text("HealthCard",style:defaultStyle()))
                              ]
                            ):
                            Column(
                              children:[
                                Center(child:Text("You did not Upload your Health card",style:defaultStyle())),
                                
                              ]
                            ),
                         

                            licences !="" ?Column(
                              children:[
                                Padding(
                                   padding: EdgeInsets.all(10.0),
                                  child: Image(
                              image:NetworkImage(licences)
                                )),
                            Padding(

                              padding: EdgeInsets.all(20.0),

                           child: Text("LicencesCard",style:defaultStyle()))
                              ]
                            ):
                            Column(
                              children:[
                                Center(child:Text("You did not Upload your Licences card",style:defaultStyle())),
                                
                              ]
                            ),
                         
                            

                          ]


                        );

          }
        )
      ))
    );
  }

}