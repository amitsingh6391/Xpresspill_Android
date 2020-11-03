import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/Product.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/pages/screens/editProductScreen.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:my_xpresspill/widgets/drawer.dart';
import 'package:my_xpresspill/widgets/defaultTextStyleTheme.dart';


class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  Stream<QuerySnapshot> allProducts;
  UserService userService = UserService();


  @override
  void initState() {
    super.initState();
    var products=productsRef.snapshots();
    setState(() {
      allProducts=products;
    });
  }

  StreamBuilder buildProductResults()
  {
    return StreamBuilder(
      stream: allProducts,
      builder: (context,snapshot){
        if(!snapshot.hasData)
        {
          return Center(child: CircularProgressIndicator());
        }
        List<ProductResult> searchResults=[];
        snapshot.data.documents.forEach((doc){
          Product product=Product.fromDocument(doc);
          ProductResult searchResult=ProductResult(product);
          searchResults.add(searchResult);
        });
        return ListView.builder(
            reverse: true,
            itemCount:snapshot.data.documents.length,
            itemBuilder: (context,index){
              Product product=Product.fromDocument(snapshot.data.documents[index]);
              return  ProductResult(product);
            }
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Products",style: defaultStyle(color: Colors.white),),
        backgroundColor: primaryColor,
        centerTitle: true,

      ),
      body: allProducts==null?Center(child: CircularProgressIndicator()):buildProductResults(),
      drawer:  MyDrawer(),
    );
  }
}


class ProductResult extends StatefulWidget {
  final Product product;

  ProductResult(this.product);
  @override
  _ProductResultState createState() => _ProductResultState(this.product);
}

class _ProductResultState extends State<ProductResult> {
  final Product product;

  _ProductResultState(this.product);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 400,
      child: Card(

        child: Column(

          children: <Widget>[
            ListTile(
              title: Text("${product.productName}"),
              subtitle: Text("${product.productDescription}"),
              trailing: IconButton(icon: Icon(FontAwesome.edit),
                onPressed: ()
                {
                  print("here------------");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProductScreen(product)),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: 200,
                child: CachedNetworkImage(imageUrl:"${product.mediaUrl}" ),
              ),
            ),
            ListTile(
              title: Text("Price : ${product.productPrice}\$"),
              trailing: Text("Quantity Left\n ${product.productQuantity}"),
            ),

          ],
        ),
      ),
    );
  }
}

