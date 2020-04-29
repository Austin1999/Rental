import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class ChatHomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ChatHomeScreen> {
  
   navigateToChat(DocumentSnapshot message){
    Navigator.push(context, MaterialPageRoute(builder:(context) => ChatPage(messages: message,)));
  }

  Future getData()async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("messages").getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
              child: Column(
          children: <Widget>[
            Container(
              color: Colors.redAccent,
              height:100.0,
              child: Center(
               child: Text('Messages',
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 25.0,
               ),),
              ),
            ),
            Container(
              height: 601.1,
              decoration: BoxDecoration(
                 color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45.0),
                  topRight: Radius.circular(45.0)
                ),
                 image: DecorationImage(
              colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.03), BlendMode.dstATop),
              image: AssetImage('assets/skyscraper.jpg'),
              fit: BoxFit.cover,
                ),
              ),
              child: FutureBuilder(
                future: getData(),
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Center(child: CircularProgressIndicator());
                  }else{
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context,index){
                        DocumentSnapshot msg = snapshot.data[index];
                        return Stack(
                    children:<Widget>[
                      Column(
                                    children: <Widget>[
                                      ListTile(
                                        contentPadding: EdgeInsets.all(10),
                                        title: Text( '${msg['name']}', 
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold
                                      ),),
                                      subtitle: Text('${msg['content']}'),
                                      onTap: (){
                                         navigateToChat(msg);
                                      },
                                     ),
                                    
                                    ]
                                  ),
                    ]
                  );
                      });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}