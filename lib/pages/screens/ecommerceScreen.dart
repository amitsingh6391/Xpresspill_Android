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

var prev_quant, prev_price;

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
    super.initState();
    var products = productsRef.snapshots();
    setState(() {
      allProducts = products;
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Icon(
                AntDesign.shoppingcart,
                size: 30,
              ),
              color: primaryColor2,
              onPressed: () {
                Navigator.of(context).pushNamed("/usercart");
              },
            ),
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
  String currentUserId;

  @override
  void initState() {
    _getCurrentUserId();

    super.initState();
  }

  _getCurrentUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = preferences.getString("userId");
    });
  }

  // additem(String quant) async {
  //   await FirebaseFirestore.instance
  //       .collection("cart")
  //       .doc(currentUserId)
  //       .collection("items")
  //       .doc(product.productId)
  //       .set({
  //     "itemname": product.productName,
  //     "itemprice": product.productPrice,
  //     "itemQuantity": 1,
  //     "itemUrl": product.mediaUrl
  //   });

  //   print("ok i add this product in cart");
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 400,
      child: Card(
        child: Column(
          children: <Widget>[
            // FutureBuilder(
            //     future: FirebaseFirestore.instance
            //         .collection("cart")
            //         .doc(currentUserId)
            //         .collection("items")
            //         .doc(product.productId)
            //         .get(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasError) {
            //         return Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Text("Connection failed."),
            //         );
            //       }
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: LinearProgressIndicator(),
            //         );
            //       }
            //       if (snapshot.hasData) {

            //         prev_quant = snapshot.data.
            //        return Container(

            //         );
            //       }
            //       return
            //            Text("No data");
            //     }),
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
                onPressed: () {
                  //print("previous quant:    $x");

                  // additem(x.toString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
