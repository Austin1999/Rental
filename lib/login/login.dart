import 'package:flutter/material.dart';
import 'adminlogin.dart';
import 'userlogin.dart';
 
class LoginPage extends StatefulWidget {
  @override
  _State createState() => _State();
}
 
class _State extends State<LoginPage> with TickerProviderStateMixin {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: AssetImage('assets/skyscraper.jpg'),
          fit: BoxFit.cover,
        ),
      ),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(40),
                    child:
                    Text(
                      'Manage Your Rentals',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
               SizedBox(
                  height: 250.0,
                ),
                Container(
                  height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FloatingActionButton.extended(
                      heroTag: 'login1',
                      elevation: 25.0,
                      backgroundColor: Colors.white,
                      label: Text('Admin',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20
                      ),),
                      onPressed: () {
                         Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => AdminLogin()),
                        );
                      },
                    )),
                    SizedBox(
                  height: 50.0,
                ),
                Container(
                  height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: FloatingActionButton.extended(
                      heroTag: 'login2',
                      elevation: 25.0,
                      backgroundColor: Colors.white,
                      label: Text('User',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20
                      ),),
                      onPressed: () {
                         Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => UserLogin()),
                        );
                      },
                    )),
              ],
            )));
  }
}