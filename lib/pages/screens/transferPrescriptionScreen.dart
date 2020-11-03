import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/widgets/progress-indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TransferPrescriptionScreen extends StatefulWidget {
  @override
  _TransferPrescriptionScreenState createState() =>
      _TransferPrescriptionScreenState();
}

class _TransferPrescriptionScreenState
    extends State<TransferPrescriptionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController pharmacyNameController =
      new TextEditingController();
  final TextEditingController pharmacyAddressController =
      new TextEditingController();
  final TextEditingController pharmacyZipCodeController =
      new TextEditingController();
  final TextEditingController pharmacyContactController =
      new TextEditingController();
  String errorMsg = "";
  bool _isLoading = false;
  String requestId = Uuid().v4();
  String _userId;
  SharedPreferences preferences;

  _getUserId() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _userId = preferences.getString("userId");
    });
  }

  @override
  void initState() {
    _getUserId();
    super.initState();
  }

  @override
  void dispose() {
    pharmacyNameController.dispose();
    pharmacyAddressController.dispose();
    pharmacyZipCodeController.dispose();
    pharmacyContactController.dispose();
    super.dispose();
  }

  _createRequestInFireStore(
      {String name, String address, String contactNumber, String zipCode}) {
    FirebaseFirestore.instance
        .collection("prescriptionTransfers")
        .doc(requestId)
        .set({
      'requestId': requestId,
      'userId': _userId,
      'name': name,
      'address': address,
      'zipCode': zipCode,
      'contactNumber': contactNumber,
      'isCompleted': false,
      'isLocked': false,
      'lockedBy': "",
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  handleSubmitForTransfer() {
    if (pharmacyAddressController.text != "" &&
        pharmacyZipCodeController.text != "" &&
        pharmacyContactController.text != "") {
      if (pharmacyZipCodeController.text.length != 6) {
        showInSnackBar("ZipCode must be of 6 characters");
      } else if (pharmacyContactController.text.length < 10) {
        showInSnackBar("Phone must be greater or equal to 10 digits");
      } else {
        setState(() {
          _isLoading = true;
        });
        String name = pharmacyNameController.text.trim();
        String address = pharmacyAddressController.text.trim();
        String zipCode = pharmacyZipCodeController.text.trim();
        String contactNumber = pharmacyContactController.text.trim();
        _createRequestInFireStore(
            name: name,
            address: address,
            zipCode: zipCode,
            contactNumber: contactNumber);
        pharmacyNameController.clear();
        pharmacyAddressController.clear();
        pharmacyZipCodeController.clear();
        pharmacyContactController.clear();
        setState(() {
          _isLoading = false;
          requestId = Uuid().v4();
        });
        showInSnackBar("Request Send Successfully");
      }
    } else {
      showInSnackBar("Please enter all details.");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: primaryColor,
        ),
        body: _isLoading
            ? circularProgress()
            : ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.place_rounded),
                    title: Container(
                      width: 250.0,
                      child: TextField(
                        controller: pharmacyNameController,
                        decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: TextStyle(fontFamily: primaryFontFamily),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.place_rounded),
                    title: Container(
                      width: 250.0,
                      child: TextField(
                        controller: pharmacyAddressController,
                        decoration: InputDecoration(
                          hintText: "Address",
                          hintStyle: TextStyle(fontFamily: primaryFontFamily),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.place_outlined),
                    title: Container(
                      width: 250.0,
                      child: TextField(
                        controller: pharmacyZipCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Zip Code",
                          hintStyle: TextStyle(fontFamily: primaryFontFamily),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.phone),
                    title: Container(
                      width: 250.0,
                      child: TextField(
                        controller: pharmacyContactController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Phone",
                          hintStyle: TextStyle(fontFamily: primaryFontFamily),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ButtonTheme(
                      minWidth: 250.0,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(36),
                            side: BorderSide(color: primaryColor)),
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        color: primaryColor,
                        textColor: Colors.white,
                        child: Text(
                          'Request Transfer',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: primaryFontFamily),
                        ),
                        onPressed: () {
                          handleSubmitForTransfer();
                        },
                      ),
                    ),
                  )
                ],
              ));
  }
}
