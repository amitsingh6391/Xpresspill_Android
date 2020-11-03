import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/Product.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/widgets/progress-indicator.dart';

class EditProductScreen extends StatefulWidget {
  Product product;
  EditProductScreen(this.product);
  @override
  _EditProductScreenState createState() =>
      _EditProductScreenState(this.product);
}

class _EditProductScreenState extends State<EditProductScreen> {
  Product product;
  _EditProductScreenState(this.product);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController productNameController =
      new TextEditingController();
  final TextEditingController productPriceController =
      new TextEditingController();
  final TextEditingController productQuantityController =
      new TextEditingController();
  final TextEditingController productDescriptionController =
      new TextEditingController();
  String errorMsg = "";
  File file;
  bool isUploading = false;

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  updatePostInFirestore(
      {String productName,
      String productPrice,
      String productQuantity,
      String productDescription}) {
    productsRef.doc(product.productId).get().then((DocumentSnapshot doc) {
      doc.reference.update({
        "productName": productName,
        "productPrice": productPrice,
        "productQuantity": productQuantity,
        "productDescription": productDescription,
        "updatedAt": DateTime.now()
      });
    });
  }

  handleSubmit() {
    if (productNameController.text != "" &&
        productPriceController.text != "" &&
        productQuantityController.text != "" &&
        productDescriptionController.text != "") {
      updatePostInFirestore(
          productName: productNameController.text.trim(),
          productPrice: productPriceController.text.trim(),
          productQuantity: productQuantityController.text.trim(),
          productDescription: productDescriptionController.text.trim());
      productNameController.clear();
      productPriceController.clear();
      productQuantityController.clear();
      productDescriptionController.clear();
      showInSnackBar("Updated Successfully");
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      showInSnackBar("Please enter all details.");
    }
  }

  @override
  void initState() {
    super.initState();
    productNameController.text = product.productName;
    productPriceController.text = product.productPrice;
    productQuantityController.text = product.productQuantity;
    productDescriptionController.text = product.productDescription;
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: null),
        title: Text(
          "Edit product",
          style: TextStyle(color: Colors.black, fontFamily: primaryFontFamily),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Update",
              style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: primaryFontFamily),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? linearProgress() : Text(""),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("${product.mediaUrl}"),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: Icon(Icons.label),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  hintText: "Product Name",
                  hintStyle: TextStyle(fontFamily: primaryFontFamily),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: productPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Product price",
                  hintStyle: TextStyle(fontFamily: primaryFontFamily),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.equalizer),
            title: Container(
              width: 250.0,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: productQuantityController,
                decoration: InputDecoration(
                  hintText: "Product Quantity",
                  hintStyle: TextStyle(fontFamily: primaryFontFamily),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.description),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: productDescriptionController,
                decoration: InputDecoration(
                  hintText: "Product Description",
                  hintStyle: TextStyle(fontFamily: primaryFontFamily),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildUploadForm();
  }
}
