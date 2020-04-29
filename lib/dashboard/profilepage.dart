import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future getData() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('admin').getDocuments();
    return qn.documents;
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _aadhaar = TextEditingController();
  TextEditingController _address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Profile Page',
        style: TextStyle(
          fontSize: 25.0
        ),)),
        backgroundColor: Colors.redAccent,
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
      child:
            FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot admin = snapshot.data[index];
                          return
                          Stack(
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.red.withOpacity(0.8)),
              clipper: getClipper(),
            ),
            Positioned(
              width: 380.0,
              top: MediaQuery.of(context).size.height / 12,
              child: Column(children: <Widget>[
                Stack(children: [
                  Center(
                    child: Container(
                        width: 100.0,
                        height: 100.0,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(
                                    admin['image']),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black),
                            ])),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * .02,
                        left: MediaQuery.of(context).size.height * .15,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: IconButton(
                            icon: Icon(Icons.mode_edit,
                                color: Colors.black, size: 25.0),
                            onPressed: () async {
                              File img = await ImagePicker.pickImage(
                                  source: ImageSource.gallery);
                              final StorageReference ref = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child('Admin/Admin');
                              StorageUploadTask task = ref.putFile(img);
                              StorageTaskSnapshot downloadUrl =
                                  (await task.onComplete);
                              String url =
                                  (await downloadUrl.ref.getDownloadURL());
                              Firestore.instance
                                  .collection('admin')
                                  .document('CguDTwnydqQxutwR5MOOBE3zcN82')
                                  .updateData({"image": url});
                              Toast.show("Profile Picture Updated", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            }),
                      )),
                ]),
                SizedBox(height: 25.0),
                Text(
                  'Admin',
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
              ]),
            ),
                           Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 240.0),
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
                                                            .collection('admin')
                                                            .document(
                                                                'CguDTwnydqQxutwR5MOOBE3zcN82')
                                                            .updateData({
                                                          "name": _name.text
                                                        });
                                                        if (_formKey
                                                            .currentState
                                                            .validate()) {
                                                          _formKey.currentState
                                                              .save();
                                                          Navigator.pop(
                                                              context);
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
                                      Text('Name : ${admin['name']}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.0,
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
                                                    controller: _email,
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
                                                            .collection('admin')
                                                            .document(
                                                                'CguDTwnydqQxutwR5MOOBE3zcN82')
                                                            .updateData({
                                                          "Email": _email.text
                                                        });
                                                        _formKey.currentState
                                                            .save();
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
                                      Text('Rent : ${admin['Email']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          )),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                                FlatButton(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('phone : ${admin['phone']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                            )),
                                        Icon(Icons.edit),
                                      ],
                                    ),
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
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      controller: _phone,
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Phone',
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                              .collection(
                                                                  'admin')
                                                              .document(
                                                                  'CguDTwnydqQxutwR5MOOBE3zcN82')
                                                              .updateData({
                                                            "phone": _phone.text
                                                          });
                                                          _formKey.currentState
                                                              .save();
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  )
                                                ],
                                              ),
                                            ));
                                          });
                                    },
                                    onLongPress: () =>
                                        launch("phone : ${admin['phone']}")),
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
                                                            .collection('admin')
                                                            .document(
                                                                'CguDTwnydqQxutwR5MOOBE3zcN82')
                                                            .updateData({
                                                          "aadhaar":
                                                              _aadhaar.text
                                                        });
                                                        _formKey.currentState
                                                            .save();
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
                                      Text('Aadhaar No : ${admin['aadhaar']}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
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
                                                    controller: _address,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Enter Your address',
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
                                                            .collection('admin')
                                                            .document(
                                                                'CguDTwnydqQxutwR5MOOBE3zcN82')
                                                            .updateData({
                                                          "city": _address.text
                                                        });
                                                        _formKey.currentState
                                                            .save();
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
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 300,
                                        ),
                                        child:
                                            Text('Address : ${admin['city']}',
                                                softWrap: false,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0,
                                                )),
                                      ),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ])]);
                        });
                  }
                }),
          
        ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 3.7);
    path.lineTo(size.width + 100, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
