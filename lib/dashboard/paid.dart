import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Paid extends StatefulWidget {
  
  final DocumentSnapshot list,flat;
  Paid({this.list, this.flat});
    
  @override
  _PaidState createState() => _PaidState();
}

class _PaidState extends State<Paid> {

  Future _data;
  Future getFlats()async {
    var firestore = Firestore.instance;

   QuerySnapshot qn = await firestore.collection('places').document(widget.flat.documentID).collection('flats').document(widget.list.documentID).collection('users').where("rentstatus", isEqualTo: 'paid').getDocuments();
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
        title:Text('Paid User List'),
        backgroundColor: Colors.redAccent,
      ),
      body: 
      Container(
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
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,index){
                  DocumentSnapshot listdetail = snapshot.data[index];
                  return Stack(
                    children:<Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100.0,
                            child: Material(
                              color: Colors.white,
                              elevation: 1.0,
                              shadowColor: Color(0x802196F3),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text( 'Name: ${listdetail['name']}', 
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold
                                      ),),
                                      trailing: Text('Expense : ₹${listdetail['total_amount']}\n Rent : ₹${listdetail['rent']}'),
                                      subtitle: Text('Flat No: ${listdetail['flat']}'),
                                      ),
                                    
                                    ]
                                  ),
                              ),)
                            ),
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
    );
  }
}