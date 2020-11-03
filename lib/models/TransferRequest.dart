
import 'package:cloud_firestore/cloud_firestore.dart';

class TransferRequest{
  String requestId;
  String userId;
  String pharmacyName;
  String pharmacyAddress;
  String pharmacyZipCode;
  String pharmacyContactNumber;
  bool isCompleted;
  bool isLocked;
  String lockedBy;

  TransferRequest({
   this.requestId,
   this.userId,
   this.pharmacyName,
   this.pharmacyAddress,
   this.pharmacyZipCode,
   this.pharmacyContactNumber,
   this.isCompleted,
    this.isLocked,
    this.lockedBy,
  });

  factory TransferRequest.fromDocument(DocumentSnapshot doc)
  {
    return TransferRequest(
      requestId: doc['requestId'],
      userId: doc['userId'],
      pharmacyName: doc['name'],
      pharmacyAddress: doc['address'],
      pharmacyZipCode: doc['zipCode'],
      pharmacyContactNumber: doc['contactNumber'],
      isCompleted: doc['isCompleted'],
      isLocked: doc['isLocked'],
      lockedBy: doc['lockedBy']
    );
  }

}