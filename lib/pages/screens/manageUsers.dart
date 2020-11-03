import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:my_xpresspill/constants.dart';
import 'package:my_xpresspill/models/User.dart';
import 'package:my_xpresspill/pages/home.dart';
import 'package:my_xpresspill/services/userService.dart';
import 'package:my_xpresspill/widgets/drawer.dart';
import 'package:my_xpresspill/widgets/defaultTextStyleTheme.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  Future<QuerySnapshot> allUsers;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    Future<QuerySnapshot> users =
        userRef.where("isAdmin", isEqualTo: false).getDocuments();
    setState(() {
      allUsers = users;
    });
  }

  FutureBuilder buildSearchResults() {
    return FutureBuilder(
      future: allUsers,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        List<UserResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          MyUser user = MyUser.fromDocument(doc);
          UserResult searchResult = UserResult(user);
          print(user.firstName);
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Manage Users",
          style: defaultStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: allUsers == null ? Container() : buildSearchResults(),
      drawer: MyDrawer(),
    );
  }
}

class UserResult extends StatefulWidget {
  final MyUser user;
  UserResult(this.user);
  @override
  _UserResultState createState() =>
      _UserResultState(this.user, this.user.isPharmacist);
}

class _UserResultState extends State<UserResult> {
  final MyUser user;
  bool isPharmacist;
  _UserResultState(this.user, this.isPharmacist);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(),
        title: Text(
          "${user.firstName} ${user.lastName}",
          style: defaultStyle(),
        ),
        subtitle: Text(
          "${isPharmacist ? "Pharmacist" : "User"}",
          style: defaultStyle(),
        ),
        trailing: IconButton(
          icon: Icon(FontAwesome.edit),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "User",
                          style: defaultStyle(),
                        ),
                        onPressed: () {
                          print(user.id);
                          userRef
                              .document(user.id)
                              .get()
                              .then((DocumentSnapshot doc) {
                            doc.reference.updateData(
                                <String, dynamic>{"isPharmacist": false});
                            setState(() {
                              isPharmacist = false;
                            });
                            Navigator.of(context).pop();
                          }).catchError((onError) {});
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Pharmacist",
                          style: defaultStyle(),
                        ),
                        onPressed: () {
                          print(user.id);
                          userRef
                              .document(user.id)
                              .get()
                              .then((DocumentSnapshot doc) {
                            doc.reference.updateData(
                                <String, dynamic>{"isPharmacist": true});
                            setState(() {
                              isPharmacist = true;
                            });
                            Navigator.of(context).pop();
                          }).catchError((onError) {});
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "Cancel",
                          style: defaultStyle(),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
