import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_prototype/login/auth.dart';
import 'flat.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future _data;
  Future getData()async{
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection('places').getDocuments();
    return qn.documents;
  }
   @override
  void initState() {
    super.initState();
    _data = getData();
  }

  navigateToAppartment(DocumentSnapshot ref){
    Navigator.push(context, MaterialPageRoute(builder:(context) => Flats(flat: ref,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Places'),
        backgroundColor: Colors.redAccent,
        actions:[
          FlatButton(child: Text('LogOut',
          style: TextStyle(
            color: Colors.white,
          )),
          onPressed: ()async {
                 await Provider.of<AuthService>(context).logout();
                },)
        ]
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
        child: FutureBuilder(
          future: _data,
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            else{
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemCount: snapshot.data.length,
                itemBuilder: (context,index){
                  DocumentSnapshot flat = snapshot.data[index];
                  return Stack(
                    children:<Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 260.0,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0, left: 15.0, right: 15.0),
                          child: Material(
                            color: Colors.white,
                            elevation: 10.0,
                            shadowColor: Color(0x802196F3),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Image.network(
                                        '${flat['image']}',
                                        height: 110.0,
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
                      )
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