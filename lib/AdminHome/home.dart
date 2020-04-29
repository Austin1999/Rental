import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:rental_prototype/AdminHome/detail.dart';
import 'package:rental_prototype/login/auth.dart';
import 'package:toast/toast.dart';

import 'notification.dart';

class Home extends StatefulWidget {
  final DocumentSnapshot list, flat;
  Home({this.list, this.flat});

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Home> {
  _updateData() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var r = await _auth.createUserWithEmailAndPassword(
        email: _email.text, password: _password.text);
    var u = r.user;
    UserUpdateInfo info = UserUpdateInfo();
    await u.updateProfile(info);
    await Firestore.instance.collection('user').document(u.uid).setData({
      "name": _name.text,
      "rent": _rent.text,
      "aadhaar": _aadhaar.text,
      "phone": _phone.text,
      "flat": _flat.text,
      "uid": u.uid,
      "rentstatus": 'Not paid',
      "lastupdated": 'Not Yet Paid',
      "appartment_id": widget.list.documentID,
    });
    Firestore.instance
        .collection('places')
        .document(widget.flat.documentID)
        .collection('flats')
        .document(widget.list.documentID)
        .collection('users')
        .document(u.uid)
        .setData({
      "name": _name.text,
      "rent": _rent.text,
      "aadhaar": _aadhaar.text,
      "phone": _phone.text,
      "flat": _flat.text,
      "uid": u.uid,
      "rentstatus": 'Not paid',
      "total_amount": 0,
      "lastupdated": 'Not Yet Paid',
    });
  }

  TextEditingController _name = TextEditingController();
  TextEditingController _aadhaar = TextEditingController();
  TextEditingController _flat = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _rent = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  navigateToDetail(DocumentSnapshot post, flat, list) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  detail: post,
                  appartment: flat,
                  user: list,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('User List'),
          backgroundColor: Colors.redAccent,
         actions: <Widget>[
           IconButton(icon: Icon(Icons.notifications),
             iconSize: 35.0,
          onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage(flat: widget.list)));
          }),
           IconButton(icon: Icon(Icons.home),
           iconSize: 40.0,
        onPressed: (){
           Navigator.of(context).popUntil((route) => route.isFirst);
        }),
        ],),
        key: _scaffoldKey,
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
        child: StreamBuilder(
            stream: Firestore.instance
        .collection('places')
        .document(widget.flat.documentID)
        .collection('flats')
        .document(widget.list.documentID)
        .collection('users')
        .snapshots(),
            builder: (context, snapshot)  {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              
              else {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot listdetail = snapshot.data.documents[index];
                      return Slidable(
                        actionPane: SlidableBehindActionPane(),
                        actionExtentRatio: 0.30,
                        child: Container(
                          height: 90.0,
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                color: Colors.black12
                              )),
                            ),
                            child: Center(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.redAccent,
                                  child: Icon(Icons.home, 
                                  color: Colors.white)
                                ),
                              title: Text(
                                'Flat No: ${listdetail['flat']}',
                                style: TextStyle(
                                    fontSize: 18.0, fontWeight: FontWeight.bold),
                              ),
                           
                              onTap: () {
                                navigateToDetail(
                                    listdetail, widget.flat, widget.list);
                              }
                                   ),
                            ),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,     
                            onTap: ()async{
                             await Firestore.instance
        .collection('places')
        .document(widget.flat.documentID)
        .collection('flats')
        .document(widget.list.documentID)
        .collection('users')
        .document(listdetail.documentID).delete();
        await Firestore.instance.collection('user').document(listdetail.documentID).delete();
        
                            },
                               )
                        ],
                        
                      );
                      
                    }
                    );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                              labelText: 'email',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _password,
                            decoration: InputDecoration(
                              labelText: 'password',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _flat,
                            decoration: InputDecoration(
                              labelText: 'Flat No',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _name,
                            decoration: InputDecoration(
                              labelText: 'Renter Name',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _aadhaar,
                            decoration: InputDecoration(
                              labelText: 'Aadhaar No',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _phone,
                            decoration: InputDecoration(
                              labelText: 'Phone No',
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _rent,
                            decoration: InputDecoration(
                              labelText: 'Rent Amount',
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                              color: Colors.redAccent,
                              child: Text(
                                'Add User',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                _scaffoldKey.currentState.showSnackBar(
                                               SnackBar(content: Text('Registering User Please Wait......'),
                                                duration: Duration(seconds: 3),
                                                elevation: 10.0,),
                                             );
                                _updateData();
                                if (_formKey.currentState.validate()) {
                                  Navigator.pop(context);
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                ));
              });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
