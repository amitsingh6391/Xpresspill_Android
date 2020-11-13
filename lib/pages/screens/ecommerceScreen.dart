

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/Product.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:my_xpresspill/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:my_xpresspill/pages/screens/userCartScreen.dart";
import 'package:fluttertoast/fluttertoast.dart';

var prev_quant, prev_price;
String currentUserId, userfirstname, usermobile, userlastname, username;
var no; //number of item in cart;

TextStyle defaultStyle() {
  return TextStyle(
    fontFamily: primaryFontFamily,
  );
}

class EcommerceScreen extends StatefulWidget {
  @override
  _EcommerceScreenState createState() => _EcommerceScreenState();
}

class _EcommerceScreenState extends State<EcommerceScreen> {
  Stream<QuerySnapshot> allProducts;
  UserService userService = UserService();

  @override
  void initState() {
    getnumberofcartitem();
    super.initState();
    var products = productsRef.snapshots();
    setState(() {
      allProducts = products;
    });
  }

  getnumberofcartitem() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    no = sharedPreferences.getInt('cartno');

    setState(() {
      no = sharedPreferences.getInt('cartno');
    });
  }

  StreamBuilder buildProductResults() {
    return StreamBuilder(
      stream: allProducts,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        List<UserProductResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          Product product = Product.fromDocument(doc);
          UserProductResult searchResult = UserProductResult(product);
          print(searchResult);
          searchResults.add(searchResult);
        });
        return ListView.builder(
            reverse: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              Product product =
                  Product.fromDocument(snapshot.data.documents[index]);
              return UserProductResult(product);
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Buy Products",
          style: defaultStyle(),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
                height: 150.0,
                width: 30.0,
                child: new GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserCartScreen(currentuserid: currentUserId)));
                  },
                  child: new Stack(
                    children: <Widget>[
                      new IconButton(
                        icon: new Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: null,
                      ),
                      no == null
                          ? new Container()
                          : new Positioned(
                              child: new Stack(
                              children: <Widget>[
                                new Icon(Icons.brightness_1,
                                    size: 20.0, color: Colors.green[800]),
                                new Positioned(
                                    top: 3.0,
                                    right: 4.0,
                                    child: new Center(
                                      child: new Text(
                                        no.toString(),
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            )),
                    ],
                  ),
                )),
          )
        ],
      ),
      body: allProducts == null
          ? Center(child: CircularProgressIndicator())
          : buildProductResults(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor2,
        child: Icon(Icons.home),
        onPressed: () {
          Navigator.of(context).pushReplacementNamed('/userhome');
        },
      ),
    );
  }
}

class UserProductResult extends StatefulWidget {
  final Product product;

  UserProductResult(this.product);
  @override
  _UserProductResultState createState() =>
      _UserProductResultState(this.product);
}

class _UserProductResultState extends State<UserProductResult> {
  final Product product;

  _UserProductResultState(this.product);

  @override
  void initState() {
    _getCurrentUserId();

    super.initState();
  }

  _getCurrentUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = preferences.getString("userId");
      usermobile = preferences.getString("userContactNumber");
      userfirstname = preferences.getString("userFirstName");
      userlastname = preferences.getString("userLastName");
      username = userfirstname + userlastname;
    });
  }

  additem() async {
    //additem function will be invoked when user want to add item in their cart
    await FirebaseFirestore.instance
        .collection("cart")
        .doc(currentUserId)
        .collection("items")
        .doc(product.productId)
        .set({
      "itemname": product.productName,
      "itemprice": product.productPrice,
      "itemQuantity": 1,
      "itemUrl": product.mediaUrl,
      "productid": product.productId,
      "userid": currentUserId,
      "maxqty":product.productQuantity
      
    });

    print("ok i add this product in cart");

    Fluttertoast.showToast(
      msg: "Your Item is add in Cart",
      fontSize: 15,
      backgroundColor: Colors.black,
      toastLength: Toast.LENGTH_LONG,
      textColor: Colors.white,
    );
    addproductonpharmapage();
  }

  //addd prdoucts at pharmasicst page

  addproductonpharmapage() async {
    //additem function will be invoked when user want to add item in their cart
    await FirebaseFirestore.instance
        .collection("ProductOrders")
        .doc(currentUserId + product.productId)
        .set({
      "itemname": product.productName,
      "itemprice": product.productPrice,
      "itemQuantity": 1,
      "itemUrl": product.mediaUrl,
      "productid": product.productId,
      "isSubmit": false,
      "userid": currentUserId,
      "usermobile": usermobile,
      "username": username,
    });

    print("ok i add this product in pharmapage");
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
              title: Text(
                "${product.productName}",
                style: defaultStyle(),
              ),
              subtitle: Text(
                "${product.productDescription}",
                style: defaultStyle(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: 200,
                child: CachedNetworkImage(imageUrl: "${product.mediaUrl}"),
              ),
            ),
            ListTile(
              title: Text(
                "Price : ${product.productPrice}\$",
                style: defaultStyle(),
              ),
              trailing: RaisedButton(
                color: greenColor,
                textColor: Colors.white,
                child: Text(
                  "Add to Cart",
                  style: defaultStyle(),
                ),
                onPressed: () async {
                  additem();

                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  no = sharedPreferences.getInt('cartno');

                  print(no);

                  if (no == null) {
                    no = 1;
                  } else {
                    no = no + 1;
                  }

                  sharedPreferences.setInt("cartno", no);

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EcommerceScreen()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
