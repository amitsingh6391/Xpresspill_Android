import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:my_xpresspill/models/User.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
class UserService {                       //we are define useservice class inside class we will define 
  FirebaseAuth _auth = FirebaseAuth.instance;           //our whole methods ,which will be used in later.
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final storage = new FlutterSecureStorage();
  final String sharedKey = 'sharedKey';
  int statusCode;
  String msg;
  MyUser currentUserDetails;
  SharedPreferences sharedPreferences;

  void createAndStoreJWTToken(String uid) async {            //in this method we are genrate a uniquw 
                                                          //token for each users.
    var builder = new JWTBuilder();
    var token = builder
      ..expiresAt = new DateTime.now().add(new Duration(hours: 3))
      ..setClaim('data', {'uid': uid})
      ..getToken();

    var signer = new JWTHmacSha256Signer(sharedKey);
    var signedToken = builder.getSignedToken(signer);
    await storage.write(key: 'token', value: signedToken.toString());
  }

  String validateToken(String token) {
    var signer = new JWTHmacSha256Signer(sharedKey);
    var decodedToken = new JWT.parse(token);
    if (decodedToken.verify(signer)) {
      final parts = token.split('.');
      final payload = parts[1];
      final String decoded = B64urlEncRfc7515.decodeUtf8(payload);
      final int expiry = jsonDecode(decoded)['exp'] * 1000;
      final currentDate = DateTime.now().millisecondsSinceEpoch;
      if (currentDate > expiry) {
        return null;
      }
      return jsonDecode(decoded)['data']['uid'];
    }
    return null;
  }

  void logOut(context) async {             //logout function will be invoked when users want to switch 
    await storage.delete(key: 'token');  //their accounts from our app. for this we will also delete  
    sharedPreferences = await SharedPreferences.getInstance();   //their token  number
    sharedPreferences.clear();
    sharedPreferences.commit();
    Navigator.of(context).pushReplacementNamed('/');
  }

  Future<void> login(userValues) async {  //login function will be invoked at a time whe user wan to login 
    String email = userValues['email'];      //inside our app for this method we need 2 parameters taht
    String password = userValues['password'];  //are email and password.

    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((dynamic user) async {                   //if the user is successfully login then we will 
                                               //save their details in locally by using share prefer....
      User currentUser = FirebaseAuth.instance.currentUser;
      final uid = currentUser.uid;
      DocumentSnapshot doc = await userRef.doc(uid).get();
      currentUserDetails = MyUser.fromDocument(doc);
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("userId", currentUserDetails.id);
      sharedPreferences.setString(
          "userFirstName", currentUserDetails.firstName);
      sharedPreferences.setString("userLastName", currentUserDetails.lastName);
      sharedPreferences.setString("userEmail", currentUserDetails.email);
      sharedPreferences.setString(
          "userContactNumber", currentUserDetails.contactNumber);
      sharedPreferences.setBool("isAdmin", currentUserDetails.isAdmin);
      sharedPreferences.setBool(
          "isPharmacist", currentUserDetails.isPharmacist);
      createAndStoreJWTToken(uid);

      statusCode = 200;     //and at the end we will assign statuscode =200 because user login is successfull
    }).catchError((error) {
      handleAuthErrors(error); //or in case of any error we will handel that by using try and catch
    });                         //this handleautherros() function will be invoked if any kind off errors occurs
  }

  Future<String> getUserId() async {
    var token = await storage.read(key: 'token');
    var uid = validateToken(token);
    return uid;
  }

  Future<void> signup(userValues) async {
    String email = userValues['email'];
    String password = userValues['password'];   //and the same thing we nee 2 parameters at a time of signup

    print("signup proccess");
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password) //after signup we will store their 
          .then((dynamic user) {                    //information in backend.
        String uid = user.user.uid;
        _firestore.collection('users').doc(uid).set({
          'firstName': capitalizeName(userValues['firstName']),
          'lastName': capitalizeName(userValues['lastName']),
          'email': userValues['email'],
          'contactNumber': userValues['contactNumber'],
          'id': uid,
          'dob': userValues['dob'],
          'createdAt': DateTime.now(),
          'isAdmin': false,
          'isPharmacist': false
        });

        print("signup ");

        statusCode = 200;
      });
    } catch (error) {
      handleAuthErrors(error);
    }
  }

  void handleAuthErrors(error) {
    String errorCode = error.code;
    print(errorCode);
    print("yes");                       //insdie this function we are check diffrent possible error case
    switch (errorCode) {     //according to them we will assing statuscode 
      case "email-already-in-use":
        {
          statusCode = 400;
          msg = "Email ID already existed";
          print("yesss");
        }
        break;
      case "too-many-requests":
        {
          statusCode = 400;
          msg = "Please try after some time you cross your max. attempt";
          print("yesss");
        }
        break;

         case "user-not-found":
        {
          statusCode = 400;
          msg = "User not found";
          print("yesss");
        }
        break;

        

       case "invalid-email":
        {
          statusCode = 400;
          msg = "Invalid - Email";
          print("yesss");
        }
        break;
      case "wrong-password":
        {
          print("yesss");
          statusCode = 400;
          msg = "Password is wrong";
        }
    }
  }
 
  String capitalizeName(String name) {     //this function will hepls us  to captializename when user did 
    name = name[0].toUpperCase() + name.substring(1);  //not to that.
    return name;
  }

  Future<String> userEmail() async {
    User user = FirebaseAuth.instance.currentUser;
    // var user = await _auth.currentUser();
    return user.email;
  }
}
