import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';

import "package:my_xpresspill/pages/home.dart";

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

  TextStyle defaultStyle() {
    return TextStyle(
      fontFamily: primaryFontFamily,
    );
  }

  getcartitemno() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    no = sharedPreferences.getInt('cartno');

    setState(() {
      itemnumber = no;
    });

    print("itemnumber*******8");
    print(itemnumber);
  }

  quantityupdate(var newquant, var productid) async {
    //addquantity function will be invoked when user want to increase or decrease item in their cart
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(widget.currentuserid)
        .collection("items")
        .doc(productid)
        .update({
      "itemQuantity": newquant,
    });

    print("ok i add this product in cart");
    quantityupdateatpharmapage(newquant, productid);
  }

  quantityupdateatpharmapage(var newquant, var productid) async {
    //function will be invoked when user want to increase or decrease item in their cart
    await FirebaseFirestore.instance
        .collection("ProductOrders")
        .doc(widget.currentuserid + productid)
        .update({
      "itemQuantity": newquant,
    });

    print("ok i add this product in at pharma page");
  }

  removeitemfromcart(var productid) async {
    //this function will be invoked when user want to delete item from their cart..

    await FirebaseFirestore.instance
        .collection("cart")
        .doc(widget.currentuserid)
        .collection("items")
        .doc(productid)
        .delete();

    print("ok i Remove item from cart");
    removeproductfrompharmapage(productid);
  }

  removeproductfrompharmapage(var productid) async {
    //this function will be invoked when user want to delete item from their cart..

    await FirebaseFirestore.instance
        .collection("ProductOrders")
        .doc(widget.currentuserid + productid)
        .delete();

    print("ok i Remove item from pharmapage");
    decreasenumberofitematcart();
  }

  onordersubmitupdatestatus() async {
    //this function will be invoked when user want to submit item whatever in cart..

    await FirebaseFirestore.instance
        .collection("ProductOrders")
        .where("userid", isEqualTo: widget.currentuserid)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.update({"isSubmit": true});
      }
    });

    print("ok i changed status now you can remove data from cart");
    onordersubmit();
  }

  onordersubmit() async {
    //this function will be invoked when user want to submit item whatever in cart..
    var updateproduct =
        await FirebaseFirestore.instance.collection("products").get();

    await FirebaseFirestore.instance
        .collection("cart")
        .doc(widget.currentuserid)
        .collection("items")
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        updateproduct.docs.forEach((element) {
          if (element.id.contains(ds.id)) {
            FirebaseFirestore.instance
                .collection("products")
                .doc(element.id)
                .update({
              "productQuantity":
                  (int.tryParse(element.data()["productQuantity"]) -
                          ds.data()["itemQuantity"])
                      .toString()
            }).then((value) {
              ds.reference.delete();
            });
          }
        });
      }
    });

    print("ok i delete product from your cart");
  }

  decreasenumberofitematcart() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var newnumber = sharedPreferences.getInt("cartno");
    newnumber = newnumber - 1;
    sharedPreferences.setInt("cartno", newnumber);

    print("we set thAT");
  }

  removenumberofitem() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setInt("cartno", 0);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
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
          elevation: 10,
          shape: CircularNotchedRectangle(),
          child: Container(
              // color: primaryColor,
              height: 75,
              child: itemnumber == 0 || itemnumber == null
                  ? Text("")
                  : Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            onordersubmitupdatestatus();
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setInt("cartno", 0);
                            Fluttertoast.showToast(
                              msg: "Your Order is Successfully Placed",
                              fontSize: 15,
                              backgroundColor: Colors.black,
                              toastLength: Toast.LENGTH_LONG,
                              textColor: Colors.white,
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EcommerceScreen()));
                          },
                          child: Icon(AntDesign.forward,
                              size: 50, color: Colors.black),
                        )
                      ],
                    )),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Column(children: [
            StreamBuilder(
                stream: carditemRef
                    .doc(widget.currentuserid)
                    .collection("items")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Column(children: [
                      Center(
                          child: CircularProgressIndicator(
                        backgroundColor: primaryColor,
                      )),
                      Text(
                        "Loading",
                        // style:defaultStyle(color: Colors.black),
                      )
                    ]);
                  }

                  var Itemdetail = snapshot.data.documents.length;
                  print(Itemdetail);
                  print(itemnumber);

                  if (Itemdetail < 1 || itemnumber == 0 || itemnumber == null) {
                    // removenumberofitem();

                    return Column(children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      SvgPicture.asset('assets/images/7.svg', height: 300.0),
                      Text(
                        "           You Don't have any Product in Your Cart",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(50.0, 30.0, 0.0, 0.0),
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
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EcommerceScreen()));
                              // validateToken(context);
                            },
                          ),
                        ),
                      ),
                    ]);
                  } else {
                    return ListView.builder(
                        reverse: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount:
                        //         (orientation == Orientation.portrait) ? 2 : 3),
                        itemBuilder: (context, index) {
                          return Card(
                            child: Container(
                                child: Column(children: [
                              Column(children: [
                                Row(children: [
                                  Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          height: size.height * 0.17,
                                          width: size.width * 0.4,
                                          child: Image(
                                              image: NetworkImage(snapshot
                                                  .data.documents[index]
                                                  .data()["itemUrl"]),
                                              fit: BoxFit.fill))),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                snapshot.data.documents[index]
                                                    .data()["itemname"],
                                                style: defaultStyle(),
                                              ),
                                            ),
                                            // Expanded(child: Container()),
                                            // Icon(Icons.home)
                                          ]),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              "Price :${snapshot.data.documents[index].data()["itemprice"]}\$",
                                              style: defaultStyle(),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              "Quantity :${snapshot.data.documents[index].data()["itemQuantity"]}",
                                              style: defaultStyle(),
                                            ),
                                          ),
                                        ]),
                                  )
                                ]),
                                SizedBox(width: 10, height: 10),
                                Column(children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              if (snapshot.data.documents[index]
                                                      .data()["itemQuantity"] <
                                                  int.parse(snapshot
                                                      .data.documents[index]
                                                      .data()["maxqty"])) {
                                                var previousquant = snapshot
                                                    .data.documents[index]
                                                    .data()["itemQuantity"];
                                                var productid = snapshot
                                                    .data.documents[index]
                                                    .data()["productid"];

                                                print(previousquant + 1);
                                                print(productid);

                                                var newquant =
                                                    previousquant + 1;
                                                productid = productid;

                                                quantityupdate(
                                                    newquant, productid);
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "max product quantity limit reached",
                                                  fontSize: 15,
                                                  backgroundColor: Colors.black,
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  textColor: Colors.white,
                                                );
                                              }
                                            },
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: primaryColor,
                                                child: Icon(Icons.add,
                                                    color: Colors.white))),
                                        GestureDetector(
                                            onTap: () {
                                              var previousquant =
                                                  snapshot //firsty we check that is it any
                                                      .data
                                                      .documents[
                                                          index] //any item in cart or not
                                                      .data()["itemQuantity"];
                                              var productid =
                                                  snapshot //then we fetch productid for that item
                                                      .data
                                                      .documents[index]
                                                      .data()["productid"];

                                              print(previousquant - 1);
                                              print(productid);

                                              var newquant;
                                              if (previousquant > 1) {
                                                newquant = previousquant - 1;
                                              } else {
                                                //newquant = 0;
                                                removeitemfromcart(productid);
                                              }

                                              productid = productid;

                                              quantityupdate(
                                                  newquant, productid);
                                            },
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: primaryColor,
                                                child: Icon(AntDesign.minus,
                                                    color: Colors.white))),
                                        GestureDetector(
                                            onTap: () {
                                              removeitemfromcart(snapshot
                                                  .data.documents[index]
                                                  .data()["productid"]);
                                            },
                                            child: CircleAvatar(
                                                radius: 15,
                                                backgroundColor: primaryColor,
                                                child: Icon(
                                                  Icons.close,
                                                  color: primaryColor2,
                                                )))
                                      ]),
                                  SizedBox(height: 10),
                                ]),
                              ])
                            ])),
                          );
                        });
                  }
                })
          ])),
        ));
  }
}
