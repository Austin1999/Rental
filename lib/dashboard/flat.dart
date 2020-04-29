import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rental_prototype/Dashboard/User.dart';

class Flats extends StatefulWidget {
  final DocumentSnapshot flat;
  Flats({this.flat});

  @override
  _FlatsState createState() => _FlatsState();
}

class _FlatsState extends State<Flats> {
  navigateToUserList(DocumentSnapshot list, flat) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => User(list: list, flat: flat)));
  }

  Future _data;
  Future getFlats() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore
        .collection("places")
        .document(widget.flat.documentID)
        .collection('flats')
        .getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    _data = getFlats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Appartment'),
          backgroundColor: Colors.redAccent,
          actions: [
            FlatButton(
              child: Text('LogOut',
                  style: TextStyle(
                    color: Colors.white,
                  )),
              onPressed: () {},
            )
          ]),
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
        child: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot flat = snapshot.data[index];
                    return Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black38)),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 80.0,
                          child: InkWell(
                            onTap: () {
                                    navigateToUserList(flat,widget.flat);
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Image.network(
                                  '${flat['image']}',
                                  height: 150.0,
                                  width: 90.0,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  '${flat['name']}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '₹${flat['total_amount']}',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      // ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }
}
