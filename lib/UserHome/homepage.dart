import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:rental_prototype/UserHome/notification.dart';
import 'package:rental_prototype/login/auth.dart';

import 'messages/chat.dart';

class UserHome extends StatefulWidget {
  final FirebaseUser currentUser;
  UserHome(this.currentUser);
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  Future getData() async {
    QuerySnapshot qn = await Firestore.instance
        .collection("user")
        .where("uid", isEqualTo: widget.currentUser.uid)
        .getDocuments();
    return qn.documents;
  }

  Future getExpense() async {
    QuerySnapshot qn = await Firestore.instance
        .collection("user")
        .document(widget.currentUser.uid)
        .collection('expenses')
        .getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.redAccent,
        title: Text('Hi User'),
        leading: IconButton(
            icon: Icon(
              Icons.chat,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatPage(user: widget.currentUser)));
            }),
        actions: <Widget>[
       FlatButton(
            child: Text('LogOut',
                style: TextStyle(
                  color: Colors.white,
                )),
            onPressed: () async {
              await Provider.of<AuthService>(context).logout();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Card(
            elevation: 15.0,
            margin: EdgeInsets.all(20.0),
            child: Container(
              height: 400.0,
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot userdetail =
                                  snapshot.data[index];
                              return Stack(children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Name : ${userdetail['name']}',
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 20.0),
                                      Text('Rent : ${userdetail['rent']}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          )),
                                      SizedBox(height: 20.0),
                                      Text('phone : ${userdetail['phone']}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          )),
                                      SizedBox(height: 20.0),
                                      Text(
                                          'Aadhaar No : ${userdetail['aadhaar']}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          )),
                                      SizedBox(height: 20.0),
                                      Text('Flat No : ${userdetail['flat']}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          )),
                                      SizedBox(height: 20.0),
                                      Text(
                                          'Rent Status : ${userdetail['rentstatus']} \n\n Paid On - ${userdetail['lastupdated']}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          )),
                                    ]),
                                Container(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: <Widget>[
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UsrNotificationPage(notifi: userdetail['appartment_id'])));
              
                                        },
                                        color: Colors.redAccent,
                                        icon: Icon(Icons.notifications_active),
                                        iconSize: 45.0,),
                                        Text('Notifications',
                                        style: TextStyle(color: Colors.redAccent,
                                        fontSize: 10.0),),
                                    ],
                                  ),
                                )
                              ]);
                            });
                      }
                    }),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              'Expense',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            child: FutureBuilder(
              future: getExpense(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot expense = snapshot.data[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text('${expense['expense']}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    )),
                                SizedBox(height: 30.0),
                                Text('${expense['amount']}',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    )),
                              ],
                            ),
                          ],
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
