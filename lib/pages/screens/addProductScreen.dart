import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/widgets/progress-indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;
import 'package:firebase_storage/firebase_storage.dart';

TextStyle defaultStyle({FontWeight weight=FontWeight.normal,Color color=Colors.black})
{
  return TextStyle(
      fontFamily: primaryFontFamily,
      fontWeight: weight,
      color: color
  );
}

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController productNameController = new TextEditingController();
  final TextEditingController productPriceController = new TextEditingController();
  final TextEditingController productQuantityController = new TextEditingController();
  final TextEditingController productDescriptionController = new TextEditingController();
  String errorMsg = "";
  File file;
  bool isUploading = false;
  String productId = Uuid().v4();

  @override
  void dispose()
  {
    productNameController.dispose();
    productPriceController.dispose();
    productQuantityController.dispose();
    productDescriptionController.dispose();
    super.dispose();
  }


  handleTakePhoto() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      this.file = file;
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text("Add new Product",
            style: TextStyle(
                fontFamily: primaryFontFamily
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
                child: Text("Photo with Camera",
                  style: TextStyle(
                      fontFamily: primaryFontFamily
                  ),
                ), onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text("Image from Gallery",
                  style: TextStyle(
                      fontFamily: primaryFontFamily
                  ),
                ),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text("Cancel",
                style: TextStyle(
                    fontFamily: primaryFontFamily
                ),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$productId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }
  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
    storageRef.child("products/post_$productId.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  createPostInFirestore(
      {String mediaUrl, String productName, String productPrice,String productQuantity,String productDescription}) {
    FirebaseFirestore.instance.collection("products").doc(productId)
        .set({
      "productId": productId,
      "productName": productName,
      "productPrice": productPrice,
      "productQuantity": productQuantity,
      "productDescription": productDescription,
      "mediaUrl": mediaUrl,
      "createdAt": DateTime.now().toIso8601String(),
    });
  }
  clearImage() {
    setState(() {
      file = null;
    });
  }

  handleSubmit() async
  {
    if(productNameController.text!=""
        && productPriceController.text!=""
        && productQuantityController.text!=""
        && productDescriptionController.text!="")
    {
      setState(() {
        isUploading = true;
      });
      await compressImage();
      String mediaUrl = await uploadImage(file);
      createPostInFirestore(
          mediaUrl: mediaUrl,
          productName: productNameController.text.trim(),
          productPrice: productPriceController.text.trim(),
          productQuantity: productQuantityController.text.trim(),
          productDescription: productDescriptionController.text.trim()
      );
      productNameController.clear();
      productPriceController.clear();
      productQuantityController.clear();
      productDescriptionController.clear();
      setState(() {
        file = null;
        isUploading = false;
        productId = Uuid().v4();
      });
    }
    else
    {
      showInSnackBar("Please enter all details.");
    }
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: Text(
          "Add new product",
          style: TextStyle(
              color: Colors.black,
              fontFamily: primaryFontFamily
          ),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Create",
              style: TextStyle(
                  color: white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  fontFamily: primaryFontFamily
              ),
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
                      image: FileImage(file),
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
                  hintStyle:  TextStyle(
                      fontFamily: primaryFontFamily
                  ),
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
                  hintStyle:  TextStyle(
                      fontFamily: primaryFontFamily
                  ),
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
                  hintStyle:  TextStyle(
                      fontFamily: primaryFontFamily
                  ),
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
                  hintStyle:  TextStyle(
                      fontFamily: primaryFontFamily
                  ),
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

  Scaffold buildSplashScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/7.svg', height: 200.0),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: ButtonTheme(
                height: 50.0,
                minWidth: 200,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Text(
                      "Add new Product",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontFamily: primaryFontFamily,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    color: primaryColor,
                    onPressed: () => selectImage(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file==null?buildSplashScreen():buildUploadForm();
  }
}
