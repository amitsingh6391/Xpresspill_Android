import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/Product.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/pages/screens/editProductScreen.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:my_xpresspill/widgets/drawer.dart';
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
import 'package:my_xpresspill/widgets/defaultTextStyleTheme.dart';


class Productorders extends StatefulWidget {
  @override
  _ProductordersState createState() => _ProductordersState();
}

class _ProductordersState extends State<Productorders> {

  Stream<QuerySnapshot> allProducts;
  UserService userService = UserService();


  @override
  void initState() {
    super.initState();
    var products=FirebaseFirestore.instance.collection("cart").
    doc("oWcZAPKXPSXcWALKJJgwjm1OUu62").collection("items").snapshots();
    setState(() {
      allProducts=products;
    });
  }

  


  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
     
      appBar:AppBar(
        title:Text("All Orders"),
        backgroundColor: primaryColor,
      ),
      body: allProducts==null?Center(child: CircularProgressIndicator()): 
      StreamBuilder(
                    stream:allProducts,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        print("Loading");

                        return Column(
                     children:[SizedBox(height: 10.0,),
                SvgPicture.asset('assets/images/7.svg', height: 300.0),

                Text("           You Don't have any Orders",
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
              
                      },
                    ),
                  ),
                ),
                      ] );
                      }
                      
                      return GridView.builder(
                          // reverse: true,
                          // physics: NeverScrollableScrollPhysics(),
                          // padding: EdgeInsets.symmetric(horizontal: 16),
                          // itemCount: snapshot.data.documents.length,
                          // shrinkWrap: true,

                           shrinkWrap : true,
                    physics: ScrollPhysics(),
  itemCount:snapshot.data.documents.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
                          itemBuilder: (context, index) {
                            return Card(
                              child:
                                Producttile(
                                  productname: snapshot.data.documents[index]
                                      .data()["itemname"],
                                  imgUrl: snapshot.data.documents[index]
                                      .data()['itemUrl'],
                                  productquant: snapshot.data.documents[index]
                                      .data()["itemQuantity"],
                                  // productquant: snapshot.data.documents[index]
                                  //     .data()["itemQuantity"],
                                  // productquant: snapshot.data.documents[index]
                                  //     .data()["itemQuantity"],
                                ),
                              
                            );
                          });
                    },
                  ),
      drawer:  MyDrawer(),
    );
  }
}





class Producttile extends StatefulWidget {
  var productname, imgUrl, productquant;
  Producttile({
    @required this.productname,
    @required this.imgUrl,
    @required this.productquant,
  });
  @override
  _ProducttileState createState() => _ProducttileState();
}

class _ProducttileState extends State<Producttile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                Container( height:50,
                  child:Image(image:NetworkImage(widget.imgUrl,
                 ),
                 fit:BoxFit.fill
                 )),
                  Container(margin: EdgeInsets.only(top: 10),alignment: Alignment.center,
                      child: Text(widget.productname,style: TextStyle(color: Colors.black),)),

                  Row(
                    children:[
                       Container(margin: EdgeInsets.only(top: 10),alignment: Alignment.center,
                      child: Text("Oty : ",style: TextStyle(color: Colors.black,
                      fontWeight:FontWeight.bold,
                      
                      ),)),


                      Container(margin: EdgeInsets.only(top: 10),alignment: Alignment.center,
                      child: Text(widget.productquant.toString(),style: TextStyle(color: Colors.black),))
                    ]
                  )
                ],
              ),
            );
  }
}