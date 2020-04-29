import 'dart:io';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rental_prototype/AdminHome/home.dart';

import 'notification.dart';

class Appartment extends StatefulWidget {
  
  final DocumentSnapshot flat;
  Appartment({this.flat});
    
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Appartment> {
  
  TextEditingController _name = TextEditingController();

   final _formKey = GlobalKey<FormState>();
 


   navigateToUserList(DocumentSnapshot list, flat){
    Navigator.push(context, MaterialPageRoute(builder:(context) => Home(list: list,flat: flat)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title:Text('Appartment'),
          backgroundColor: Colors.redAccent,
         actions: <Widget>[
           IconButton(icon: Icon(Icons.home),
             iconSize: 40.0,
          onPressed: (){
             Navigator.of(context).popUntil((route) => route.isFirst);
          }),
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
            stream: Firestore.instance.collection("places").document(widget.flat.documentID).collection('flats').snapshots(),
            builder: (context,snapshot){
              if(!snapshot.hasData){
                return Center(child: CircularProgressIndicator());
              }
              else{
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot appartment = snapshot.data.documents[index];
                    return Stack(
                      children:<Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 270.0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                                child: Material(
                                  color: Colors.white,
                                  elevation: 14.0,
                                  shadowColor: Color(0x802196F3),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            title: Image.network(
                                              '${appartment['image']}',
                                              height: 200.0,
                                              fit: BoxFit.fill,
                                            ),
                                             subtitle: Center(
                                               child: Text( '${appartment['name']}', 
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold
                                          ),),
                                             ),
                                          onTap: (){
                                            navigateToUserList(appartment, widget.flat);
                                          },
                                          ),
                                        
                                        ]
                                      ),
                                  ),)
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(
                             top: MediaQuery.of(context).size.height *.04,
                              right: MediaQuery.of(context).size.height *.35,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: CircleAvatar(
                                backgroundColor: Colors.redAccent,
                                child: IconButton(
                                  icon :Icon(Icons.edit, color: Colors.white, size: 20.0),
                                  onPressed: ()async{
                                                
                                                  File img = await ImagePicker.pickImage(source: ImageSource.gallery);
                                                  final StorageReference ref = FirebaseStorage.instance.ref().child('city_pics/${appartment['name']}');
                                                  StorageUploadTask task = ref.putFile(img);
                                                  StorageTaskSnapshot downloadUrl = (await task.onComplete);
                                                  String url = (await downloadUrl.ref.getDownloadURL());
                                                  Firestore.instance..collection('places').document(widget.flat.documentID).collection('flats').document(appartment.documentID).updateData({"image": url});
                                                  Toast.show("Appartment Picture Updated", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                               }),)
                              ),
                            ),
                      ]
                    );
                  }
                );
              }
            }
          ),
        ),
         floatingActionButton: FloatingActionButton(
        onPressed: () {
         showDialog(context: context,
                               builder: (BuildContext context){
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
                                                  labelText: 'Apparment Name',
                                              ),
                                            ),
                                         ),
                                         Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: RaisedButton(
                                             color: Colors.redAccent,
                                             child: Text('Add Appartment',
                                             style: TextStyle(
                                               color: Colors.white,
                                             ),),
                                             onPressed:(){
                                               Firestore.instance.collection('places').document(widget.flat.documentID).collection('flats').document().setData({"name": _name.text , "total_amount":0, "image": 'https://firebasestorage.googleapis.com/v0/b/rental-app-e98b8.appspot.com/o/no_image.png?alt=media&token=f97b7785-5e61-4013-9ad0-a6bf4d5f1029'});
                                             if (_formKey.currentState.validate()) {
                                                    _formKey.currentState.save();
                                                     Navigator.pop(context);
                                                }
                                             }
                                           ),
                                         )
                                       ],
                                     ),)
                                 );
                               });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
      ),
    );
  }
}
