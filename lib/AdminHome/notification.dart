import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationPage extends StatefulWidget {
  final DocumentSnapshot flat;
  NotificationPage({this.flat});
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TextEditingController _msg = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notify the user'),
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          content: Form(
                        key: _formKey,
                        child: Container(
                          height: 290.0,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  maxLines: 8,
                                  controller: _msg,
                                  decoration: InputDecoration(
                                      hintText: 'Enter Your Message',
                                      hintStyle: TextStyle(
                                        fontSize: 20.0,
                                      )),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                    color: Colors.redAccent,
                                    child: Text(
                                      'Send Message',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      Firestore.instance
                                          .collection('notification')
                                          .document(widget.flat.documentID)
                                          .collection('notifications')
                                          .document()
                                          .setData({"msgs": _msg.text, "posted_on": DateTime.now().toString()});
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.reset();
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
            ),
          ],
        ),
        body: Container(
            child: StreamBuilder(
          stream: Firestore.instance
              .collection('notification')
              .document(widget.flat.documentID)
              .collection('notifications').orderBy('posted_on')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot notifi = snapshot.data.documents[index];
                    return Slidable(
                      actionPane: SlidableBehindActionPane(),
                        actionExtentRatio: 0.30,
                         child: Card(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('${notifi['msgs']}',
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),)],
                            ),
                          )),
                          secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Delete',
                            color: Colors.red,
                            icon: Icons.delete,     
                            onTap: (){
                              Firestore.instance
              .collection('notification')
              .document(widget.flat.documentID)
              .collection('notifications').document(notifi.documentID).delete();
                            }
                          ),
                          ],
                    );
                  });
            }
          },
        )),
      ),
    );
  }
}
