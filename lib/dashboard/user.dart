import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_prototype/dashboard/paid.dart';
import 'package:rental_prototype/dashboard/unpaid.dart';

class User extends StatefulWidget {
  final DocumentSnapshot list, flat;
  User({this.list, this.flat});
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {

  navigateToPaid(DocumentSnapshot list, flat){
    Navigator.push(context, MaterialPageRoute(builder:(context) => Paid(list: list, flat: flat,)));
  }
  navigateToUnPaid(DocumentSnapshot list, flat){
    Navigator.push(context, MaterialPageRoute(builder:(context) => UnPaid(list: list, flat: flat,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.redAccent, title: Text('Rent Status')),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.1), BlendMode.dstATop),
            image: AssetImage('assets/skyscraper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 280.0,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                  child: Material(
                    color: Colors.white,
                    elevation: 14.0,
                    shadowColor: Color(0x802196F3),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Center(
                            child: Text(
                              'Paid Users',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () {
                            navigateToPaid(widget.list, widget.flat);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 280.0,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                child: Material(
                  color: Colors.white,
                  elevation: 14.0,
                  shadowColor: Color(0x802196F3),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                          title: Center(
                            child: Text(
                              'UnPaid Users',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          onTap: () {
                            navigateToUnPaid(widget.list, widget.flat);
                          }),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
