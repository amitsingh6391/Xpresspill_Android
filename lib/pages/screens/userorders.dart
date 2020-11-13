import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:my_xpresspill/constants.dart';

import 'package:my_xpresspill/services/userService.dart';
import 'package:my_xpresspill/widgets/drawer.dart';

import 'package:my_xpresspill/widgets/defaultTextStyleTheme.dart';

import 'package:flutter_svg/svg.dart';

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
    var products = FirebaseFirestore.instance
        .collection("ProductOrders")
        .where("isSubmit", isEqualTo: true)
        .snapshots();
    setState(() {
      allProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    /*24 is for notification bar on Android*/
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("All Orders"),
        backgroundColor: primaryColor,
      ),
      body: allProducts == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder(
              stream: allProducts,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  print("Loading");

                  return Column(children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    SvgPicture.asset('assets/images/7.svg', height: 300.0),
                    Text(
                      "           You Don't have any Orders",
                      style: TextStyle(
                          fontSize: 15.0,
                          color: primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50.0, 30.0, 0.0, 0.0),
                      child: ButtonTheme(
                        minWidth: 220.0,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36)),
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          color: primaryColor,
                          textColor: Colors.white,
                          child: Text(
                            'Buy Now',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ]);
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: Producttile(
                              productname: snapshot.data.documents[index]
                                  .data()["itemname"],
                              imgUrl: snapshot.data.documents[index]
                                  .data()['itemUrl'],
                              productquant: snapshot.data.documents[index]
                                  .data()["itemQuantity"],
                              username: snapshot.data.documents[index]
                                  .data()["username"],
                              mobilenumber: snapshot.data.documents[index]
                                  .data()["usermobile"],
                              price: snapshot.data.documents[index]
                                  .data()["itemprice"],
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
      drawer: MyDrawer(),
    );
  }
}

class Producttile extends StatefulWidget {
  var productname, imgUrl, productquant, username, mobilenumber, price;
  Producttile(
      {@required this.productname,
      @required this.imgUrl,
      @required this.productquant,
      @required this.username,
      @required this.mobilenumber,
      @required this.price});
  @override
  _ProducttileState createState() => _ProducttileState();
}

class _ProducttileState extends State<Producttile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Container(
        height: size.height * 0.22,
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text(widget.username),
              subtitle: Text(widget.mobilenumber.toString()),
            ),
            Row(
              children: [
                Container(
                  // width: 135,
                  // height: 130,
                  child: Row(
                    children: [
                      Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Image(
                              image: NetworkImage(widget.imgUrl),
                              fit: BoxFit.fill)),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(children: [
                      Text(
                        widget.productname,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                    ]),
                    SizedBox(height: 10),
                    Row(children: [
                      Text(r"M.R.P :  $ "),
                      Text(
                        widget.price,
                        style: TextStyle(color: Colors.black45),
                      )
                    ]),
                    SizedBox(height: 10),
                    Row(children: [
                      Text("Qty : "),
                      Container(
                          margin: EdgeInsets.only(right: 100),
                          child: Text(
                            widget.productquant.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                    ]),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
