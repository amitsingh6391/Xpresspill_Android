import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/widgets/progress-indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as Im;

class Addhealthcard extends StatefulWidget {
  @override
  _AddhealthcardState createState() => _AddhealthcardState();
}

class _AddhealthcardState extends State<Addhealthcard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String errorMsg = "";
  File file;
  bool isUploading = false;
  String healthcardId = Uuid().v4();
  SharedPreferences sharedPreferences;

  @override
  void dispose() {
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
          title: Text(
            "Add Your Health Card",
            style: TextStyle(fontFamily: primaryFontFamily),
          ),
          children: <Widget>[
            SimpleDialogOption(
                child: Text(
                  "Photo with Camera",
                  style: TextStyle(fontFamily: primaryFontFamily),
                ),
                onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text(
                  "Image from Gallery",
                  style: TextStyle(fontFamily: primaryFontFamily),
                ),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(fontFamily: primaryFontFamily),
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
    final compressedImageFile = File('$path/img_$healthcardId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask = storageRef
        .child("healthcard/healthcard_$healthcardId.jpg")
        .putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  updateInFirestore({String mediaUrl, String userId}) {
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      "Healthcard": mediaUrl,
    });
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  handleSubmit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString("userId");
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    updateInFirestore(mediaUrl: mediaUrl, userId: userId);
    setState(() {
      file = null;
      isUploading = false;
      healthcardId = Uuid().v4();
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
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
          "Add Your Health Card",
          style: TextStyle(color: Colors.black, fontFamily: primaryFontFamily),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Upload",
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
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Scaffold buildSplashScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/7.svg', height: 300.0),
            SizedBox(height: 100),
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
                      "Add Your Health Card",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontFamily: primaryFontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    color: primaryColor,
                    onPressed: () => selectImage(context)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "Note : Please upload a clear image of your Healthcard",
                style: TextStyle(
                    fontFamily: primaryFontFamily,
                    fontSize: 15.0,
                    color: redColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}

class Addlicences extends StatefulWidget {
  @override
  _AddlicencesState createState() => _AddlicencesState();
}

class _AddlicencesState extends State<Addlicences> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String errorMsg = "";
  File file;
  bool isUploading = false;
  String licences = Uuid().v4();
  SharedPreferences sharedPreferences;

  @override
  void dispose() {
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
          title: Text(
            "Add Your Licences Card",
            style: TextStyle(fontFamily: primaryFontFamily),
          ),
          children: <Widget>[
            SimpleDialogOption(
                child: Text(
                  "Photo with Camera",
                  style: TextStyle(fontFamily: primaryFontFamily),
                ),
                onPressed: handleTakePhoto),
            SimpleDialogOption(
                child: Text(
                  "Image from Gallery",
                  style: TextStyle(fontFamily: primaryFontFamily),
                ),
                onPressed: handleChooseFromGallery),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(fontFamily: primaryFontFamily),
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
    final compressedImageFile = File('$path/img_$licences.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      file = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    StorageUploadTask uploadTask = storageRef
        .child("Licencescard/Licencescard_$licences.jpg")
        .putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  updateInFirestore({String mediaUrl, String userId}) {
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      "Licencescard": mediaUrl,
    });
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  handleSubmit() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString("userId");
    setState(() {
      isUploading = true;
    });
    await compressImage();
    String mediaUrl = await uploadImage(file);
    updateInFirestore(mediaUrl: mediaUrl, userId: userId);
    setState(() {
      file = null;
      isUploading = false;
      licences = Uuid().v4();
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
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
          "Add Your Licences Card",
          style: TextStyle(color: Colors.black, fontFamily: primaryFontFamily),
        ),
        actions: [
          FlatButton(
            onPressed: isUploading ? null : () => handleSubmit(),
            child: Text(
              "Upload",
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
                      image: FileImage(file),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Scaffold buildSplashScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset('assets/images/7.svg', height: 300.0),
            SizedBox(height: 100),
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
                      "Add Your Licences Card",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontFamily: primaryFontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    color: primaryColor,
                    onPressed: () => selectImage(context)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                "Note : Please upload a clear image of your Licencescard",
                style: TextStyle(
                    fontFamily: primaryFontFamily,
                    fontSize: 15.0,
                    color: redColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
