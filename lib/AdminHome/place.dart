import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_prototype/AdminHome/appartment.dart';
import 'package:rental_prototype/login/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

class PlacePage extends StatefulWidget {
  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> { 
  
  TextEditingController _name = TextEditingController();

   final _formKey = GlobalKey<FormState>();

  navigateToAppartment(DocumentSnapshot ref){
    Navigator.push(context, MaterialPageRoute(builder:(context) => Appartment(flat: ref,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('City'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          FlatButton(child: Text('LogOut',
          style: TextStyle(
            color: Colors.white,
          )),
          onPressed: ()async {
                  await Provider.of<AuthService>(context).logout();
                },)
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
          stream: Firestore.instance.collection('places').snapshots(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            else{              
               return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot flat = snapshot.data.documents[index];
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
                                              '${flat['image']}',
                                              height: 200.0,
                                              fit: BoxFit.fill,
                                            ),
                                             subtitle: Center(
                                               child: Text( '${flat['name']}',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold
                                          ),),
                                             ),
                                           onTap: (){
                                            navigateToAppartment(flat);
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
                                                final StorageReference ref = FirebaseStorage.instance.ref().child('city_pics/${flat['name']}');
                                                StorageUploadTask task = ref.putFile(img);
                                                StorageTaskSnapshot downloadUrl = (await task.onComplete);
                                                String url = (await downloadUrl.ref.getDownloadURL());
                                                Firestore.instance.collection('places').document(flat.documentID).updateData({"image": url});
                                                Toast.show("City Picture Updated", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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
      onPressed: () {showDialog(context: context,
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
                                                labelText: 'City Name',
                                            ),
                                          ),
                                       ),
                                      Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: RaisedButton(
                                           color: Colors.redAccent,
                                           child: Text('Add City',
                                           style: TextStyle(
                                             color: Colors.white,
                                           ),),
                                           onPressed:(){                                         
                                            Firestore.instance.collection('places').document().setData({ "name": _name.text, "image":'https://firebasestorage.googleapis.com/v0/b/rental-app-e98b8.appspot.com/o/no_image.png?alt=media&token=dbe81e9b-faae-46d2-b3b8-b8b2ba2d453c'});
                                            if (_formKey.currentState.validate()){
                                                
                                                  _formKey.currentState.save();
                                                   Navigator.pop(context);
                                              }
                                           }
                                         ),
                                       ),
                                     ],
                                   ),)
                               );
                             });
      },
      child: Icon(Icons.add),
      backgroundColor: Colors.redAccent,
    ),);
  }
}