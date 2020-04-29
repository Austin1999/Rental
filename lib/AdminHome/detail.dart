import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rental_prototype/AdminHome/expense.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  final DocumentSnapshot detail, appartment, user;
  DetailPage({this.detail, this.appartment, this.user});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  navigateToExpense(city,appartment,user){
     Navigator.push(context, MaterialPageRoute(builder:(context) => ExpensePage(flat: city,user: appartment,detail: user,)));
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _rent = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _aadhaar = TextEditingController();
  // TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('Flat No : ${widget.detail.data["flat"]}'),
        actions: <Widget>[
           IconButton(icon: Icon(Icons.home),
            iconSize: 35.0,
        onPressed: (){
           Navigator.of(context).popUntil((route) => route.isFirst);
        }),
          IconButton(
            icon: Icon(Icons.list), 
            color: Colors.white,
            iconSize: 35.0,
            onPressed: () => navigateToExpense(widget.appartment,widget.user,widget.detail,),)
        ],
      ),
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
        .document(widget.appartment.documentID)
        .collection('flats')
        .document(widget.user.documentID)
        .collection('users').document(widget.detail.documentID).snapshots(),
          builder:  (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if(DateTime.now().day == 1){
              Firestore.instance
        .collection('places')
        .document(widget.appartment.documentID)
        .collection('flats')
        .document(widget.user.documentID)
        .collection('users').document(widget.detail.documentID).updateData({'rentstatus': 'Not Paid'});
              }
              return ListView.builder(
                itemCount: 1,
                  itemBuilder: (context, index) {
                    DocumentSnapshot userdetail = snapshot.data;
                   return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 5.0,
                margin: EdgeInsets.all(15.0),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(25.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: _name,
                                              decoration: InputDecoration(
                                                labelText: 'Name',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                                color: Colors.redAccent,
                                                child: Text(
                                                  'Update',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Firestore.instance
                                      .collection('places')
                                      .document(widget.appartment.documentID)
                                      .collection('flats')
                                      .document(widget.user.documentID)
                                      .collection('users')
                                      .document(widget.detail.documentID)
                                      .updateData({"name": _name.text});
                                       Firestore.instance
                                      .collection('user')
                                      .document(widget.detail.documentID)
                                      .updateData({"name": _name.text});

                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    _formKey.currentState
                                                        .save();
                                                    Navigator.pop(context);
                                                  }
                                                }),
                                          )
                                        ],
                                      ),
                                    ));
                                  });
                            },
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Name : ${userdetail['name']}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                                Icon(Icons.edit),
                              ],
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: _rent,
                                              decoration: InputDecoration(
                                                labelText: 'Rent',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                                color: Colors.redAccent,
                                                child: Text(
                                                  'Update',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                   Firestore.instance
                                      .collection('places')
                                      .document(widget.appartment.documentID)
                                      .collection('flats')
                                      .document(widget.user.documentID)
                                      .collection('users')
                                      .document(widget.detail.documentID)
                                      .updateData({"rent":_rent.text});
                                       Firestore.instance
                                      .collection('user')
                                      .document(widget.detail.documentID)
                                      .updateData({"rent":_rent.text});
                                                  _formKey.currentState
                                                      .reset();
                                                  Navigator.pop(context);
                                                }),
                                          )
                                        ],
                                      ),
                                    ));
                                  });
                            },
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Rent : ₹${userdetail['rent']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    )),
                                Icon(Icons.edit),
                              ],
                            ),
                          ),
                         FlatButton(
                           onLongPress:() => launch('tel:${userdetail['phone']}'),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: _phone,
                                              decoration: InputDecoration(
                                                labelText: 'Phone No.',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                                color: Colors.redAccent,
                                                child: Text(
                                                  'Update',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: (){
                                                   Firestore.instance
                                      .collection('places')
                                      .document(widget.appartment.documentID)
                                      .collection('flats')
                                      .document(widget.user.documentID)
                                      .collection('users')
                                      .document(widget.detail.documentID)
                                      .updateData({"phone":_phone.text});
                                        Firestore.instance
                                      .collection('user')
                                      .document(widget.detail.documentID)
                                      .updateData({"phone":_phone.text});
                                                  _formKey.currentState
                                                      .reset();
                                                  Navigator.pop(context);
                                                },
                                          ),
                                          )],
                                      ),
                                    ));
                                  });
                            },
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Phone : ${userdetail['phone']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    )),
                                Icon(Icons.edit),
                              ],
                            ),
                          ),
                         FlatButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        content: Form(
                                      key: _formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: _aadhaar,
                                              decoration: InputDecoration(
                                                labelText: 'Aadhaar',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child: RaisedButton(
                                                color: Colors.redAccent,
                                                child: Text(
                                                  'Update',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                onPressed: () {
                                                   Firestore.instance
                                      .collection('places')
                                      .document(widget.appartment.documentID)
                                      .collection('flats')
                                      .document(widget.user.documentID)
                                      .collection('users')
                                      .document(widget.detail.documentID)
                                      .updateData({"aadhaar":_aadhaar.text});
                                       Firestore.instance
                                      .collection('user')
                                      .document(widget.detail.documentID)
                                      .updateData({"aadhaar":_aadhaar.text});
                                                  _formKey.currentState
                                                      .reset();
                                                  Navigator.pop(context);
                                                }),
                                          )
                                        ],
                                      ),
                                    ));
                                  });
                            },
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Aadhaar : ${userdetail['aadhaar']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    )),
                                Icon(Icons.edit),
                              ],
                            ),
                          ),
                          FlatButton(onPressed: null,
                           child:  Text(
                                    'Rent Status : ${userdetail['rentstatus']}\n\n (Paid On - ${userdetail['lastupdated']})',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                )),),
                          FlatButton(onPressed: null,
                           child:  Text(
                                    'Total Expense : ₹${userdetail['total_amount']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                )),),
                          SizedBox(height: 50.0),
                          Center(
                              child: Text(
                            'Rent Status',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          SizedBox(height: 30.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FloatingActionButton.extended(
                                backgroundColor: Colors.redAccent,
                                heroTag: "btn1",
                                icon: Icon(Icons.check),
                                label: Text('Paid'),
                                onPressed: () {
                                     Firestore.instance
                                      .collection('places')
                                      .document(widget.appartment.documentID)
                                      .collection('flats')
                                      .document(widget.user.documentID)
                                      .collection('users')
                                      .document(widget.detail.documentID)
                                      .updateData({"rentstatus": 'paid', "lastupdated": DateTime.now().toString()});
                                    Firestore.instance
                                      .collection('user')
                                      .document(widget.detail.documentID)
                                      .updateData({"rentstatus": 'paid', "lastupdated": DateTime.now().toString()});
                                  Toast.show("Rent Status Updated", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                },
                              ),
                              FloatingActionButton.extended(
                                backgroundColor: Colors.redAccent,
                                heroTag: "btn2",
                                icon: Icon(Icons.close),
                                label: Text('Not Paid'),
                                onPressed: () {
                                   Firestore.instance
                                      .collection('places')
                                      .document(widget.appartment.documentID)
                                      .collection('flats')
                                      .document(widget.user.documentID)
                                      .collection('users')
                                      .document(widget.detail.documentID)
                                      .updateData({"rentstatus": 'Not paid'});
                                     Firestore.instance
                                      .collection('user')
                                      .document(widget.detail.documentID)
                                      .updateData({"rentstatus": 'Not paid'});
                                  Toast.show("Rent Status Updated", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 60.0),
                          
              // Center(
              //     child: FloatingActionButton.extended(
              //   backgroundColor: Colors.redAccent,
              //   icon: Icon(Icons.lock),
              //   label: Text("Change User Password"),
              //   onPressed: () {
              //     showDialog(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return AlertDialog(
              //               content: Form(
              //             key: _formKey,
              //             child: Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: <Widget>[
              //                 Padding(
              //                   padding: EdgeInsets.all(8.0),
              //                   child: TextFormField(
              //                     controller: _password,
              //                     decoration: InputDecoration(
              //                       labelText: 'Enter New Password',
              //                     ),
              //                   ),
              //                 ),
              //                 Padding(
              //                   padding: const EdgeInsets.all(8.0),
              //                   child: RaisedButton(
              //                       color: Colors.redAccent,
              //                       child: Text(
              //                         'Change Password',
              //                         style: TextStyle(
              //                           color: Colors.white,
              //                         ),
              //                       ),
              //                       onPressed: () async {
              //                         _formKey.currentState.save();
              //                         Navigator.pop(context);
              //                       }),
              //                 )
              //               ],
              //             ),
              //           ));
              //         });
              //   },
              // )),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        );
                  });
            }})
      ),
    );
  }
}
