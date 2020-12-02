import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String contactNumber;
  final String dob;

  final String role;

  MyUser({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.contactNumber,
    this.dob,
   
    this.role,
  });

  factory MyUser.fromDocument(DocumentSnapshot doc) {
    return MyUser(
        id: doc['id'],
        firstName: doc['firstName'],
        lastName: doc['lastName'],
        email: doc['email'],
        contactNumber: doc['contactNumber'],
        dob: doc['dob'],
     
        role: doc['role']
        // healthcard: doc["healthcard"]
        );
  }
}
