import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  final String productId;
  final String productName;
  final String productPrice;
  final String productQuantity;
  final String productDescription;
  final String mediaUrl;

  Product(
      {this.productId,
      this.productName,
      this.productPrice,
      this.productQuantity,
      this.productDescription,
      this.mediaUrl});


  factory Product.fromDocument(DocumentSnapshot doc)
  {
    return Product(
      productId:doc['productId'],
      productName:doc['productName'],
      productPrice:doc['productPrice'],
      productQuantity:doc['productQuantity'],
      productDescription:doc['productDescription'],
      mediaUrl:doc['mediaUrl'],
    );
  }
}