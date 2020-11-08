import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/widgets/defaultTextStyleTheme.dart';

import "package:my_xpresspill/pages/home.dart";
import "package:my_xpresspill/constants.dart";
import "package:my_xpresspill/pages/screens/paymentscreen.dart";
import "package:my_xpresspill/pages/screens/ecommerceScreen.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/svg.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserCartScreen extends StatefulWidget {
String currentuserid;
UserCartScreen({@required this.currentuserid});
  @override
  _UserCartScreenState createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {



@override
  void initState() {
    getcartitemno();
    super.initState();
    
  }




var itemnumber; //numberof item in cart;

getcartitemno()async{
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                  no = sharedPreferences.getInt('cartno');

                  setState((){
itemnumber = no;

                  });

                  print("itemnumber*******8");
                  print(itemnumber);

}



addquantity(var newquant, var productid) async {    //addquantity function will be invoked when user want to increase item in their cart
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(widget.currentuserid)
        .collection("items")
        .doc(productid)
        .update({
      
      "itemQuantity": newquant,
     
    });

    print("ok i add this product in cart");
  }

  // ordersubmit(var productid) async {    //addquantity function will be invoked when user want to Submit their item..
  //   await FirebaseFirestore.instance
  //       .collection("cart")
  //       .doc(widget.currentuserid)
  //       .collection("items").doc(productid)
        
  //       .update({
      
  //     "isSubmit":true,
     
  //   });

  //   print("ok i  submit this product");
  // }



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Your Cart",
         // style: defaultStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),


bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          color:primaryColor,
          height: 75,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Submit",style: TextStyle(color: Colors.white,
              fontSize:30),),
              

                 GestureDetector(
                   onTap:() async{

                   //  ordersubmit();

 SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
 sharedPreferences.setInt("cartno",0);
                     Fluttertoast.showToast(
          msg: "Your Order is Successfully Placed",
          fontSize: 15,
          backgroundColor: primaryColor2,
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
        );
        Navigator.push(context,MaterialPageRoute(builder:(context)=>
               EcommerceScreen()));



            
                   },
                   child:Icon(Icons.arrow_forward,size:70,color:Colors.white),
                   )
               
            ],
          ),
        ),
      ),





      body: Container(child: Column(children: [

         StreamBuilder(
                stream: carditemRef.doc(widget.currentuserid).collection("items")
                    
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Column(children: [
                      Center(
                          child: CircularProgressIndicator(
                        backgroundColor:primaryColor,
                      )),
                      Text("Loading", 
                     // style:defaultStyle(color: Colors.black),
                      )
                    ]);
                  }

                  var Itemdetail = snapshot.data.documents.length;
                 // var quantity = snapshot.data.documents.data()["itemQuantity"];
                 print(Itemdetail);
                 print(itemnumber);


                 if(Itemdetail<1 || itemnumber==0 || itemnumber==null){
                   return  Column(
                     children:[SizedBox(height: 10.0,),
                SvgPicture.asset('assets/images/7.svg', height: 300.0),

                Text("           You Don't have any Product in Your Cart",
                 style: TextStyle(
                            fontSize: 15.0,
                            color:primaryColor,
                            fontWeight: FontWeight.bold
                        ),),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 30.0, 0.0, 0.0),
                  child: ButtonTheme(
                    minWidth: 220.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      color: primaryColor,
                      textColor: Colors.white,
                      child: Text(
                        'Buy Now',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () {
                         Navigator.push(context,MaterialPageRoute(builder:(context)=>
               EcommerceScreen()));
                       // validateToken(context);
                      },
                    ),
                  ),
                ),
                      ] );
                 }else{

                  return 
                  
                  
                  ListView.builder(
                      reverse: true,
                      physics: NeverScrollableScrollPhysics(),
                     padding: EdgeInsets.symmetric(horizontal: 6),
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Card(child:Container(


                          child:Column(
                            children:[
                              Row(
                                children:[

                                 Padding( 
                                   padding: const EdgeInsets.all(8.0),
                                   child:Container(
                                    
                                    height:size.height*0.12,
                                    width:size.width*0.3,
                                    child:Image(
                                      image:NetworkImage(snapshot.data.documents[index].data()["itemUrl"]),
                                      fit:BoxFit.fill
                                    
                                    )

                                 )),
                                  SizedBox(width:10),
                                  Column(
                                    children:[
                                      Text(snapshot.data.documents[index].data()["itemname"],style:TextStyle(
                                        fontSize:15,color:Colors.black,fontWeight:FontWeight.bold
                                      )),
                                      Text("Price :${snapshot.data.documents[index].data()["itemprice"]}\$",style:TextStyle(
                                        fontSize:15,color:Colors.black,
                                      )),

                                     
                                        
                                        Text("Quantity :${snapshot.data.documents[index].data()["itemQuantity"]}",style:TextStyle(
                                        fontSize:15,color:Colors.black,fontWeight:FontWeight.bold
                                      ))
                                     

                                ]
                              ),

                              SizedBox(width:10),

                              Column(
                                children:[
                                  GestureDetector(
                                    onTap:(){

                                      var previousquant=snapshot.data.documents[index].data()["itemQuantity"];
                                      var productid=snapshot.data.documents[index].data()["productid"];

                                      print(previousquant+1);
                                      print(productid);

                                     var newquant = previousquant+1;
                                   productid=productid;
                                      

                                      
                                      addquantity(newquant, productid);

                                    },
                                 child:CircleAvatar(
                                    backgroundColor:primaryColor,
                                    child:Icon(Icons.add,color:Colors.white)
                                  )),
                                  SizedBox(height:10),
                                 GestureDetector(
                                   
                                   onTap:(){
                                      var previousquant=snapshot.data.documents[index].data()["itemQuantity"];
                                      var productid=snapshot.data.documents[index].data()["productid"];

                                      print(previousquant-1);
                                      print(productid);

                                        var newquant;
                                      if(previousquant>0){
                                         newquant = previousquant-1;

                                      }else{
                                        newquant = 0;
                                      }


                                     
                                   productid=productid;
                                      

                                      
                                      addquantity(newquant, productid);

                                   },
                                   child: CircleAvatar(
                                    backgroundColor:primaryColor,
                                    child:Text("-",style:TextStyle(color: Colors.white,fontSize:40))
                                 ))
                                ]
                              )
                            ]
                          )

                         
                   

      ])),
    );
  }
                  );}})])));
  }}