import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsrNotificationPage extends StatefulWidget {
  var notifi;
  UsrNotificationPage({this.notifi});
  @override
  _UsrNotificationPageState createState() => _UsrNotificationPageState();
}

class _UsrNotificationPageState extends State<UsrNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Notifications'),
          backgroundColor: Colors.redAccent,
        ),
        body: Container(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('notification')
                .document(widget.notifi)
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
                      return Card(
                          child: Padding(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${notifi['msgs']}',
                              style: TextStyle(
                                fontSize: 17.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                'Posted on : ${notifi['posted_on']}',
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                      ));
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}
