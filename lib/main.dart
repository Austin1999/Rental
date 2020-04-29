import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:rental_prototype/AdminHome/homepage.dart';
import 'UserHome/homepage.dart';
import 'login/auth.dart';
import 'login/login.dart';

void main() => runApp(
      ChangeNotifierProvider<AuthService>(
        child: MyApp(),
        builder: (BuildContext context) {
          return AuthService();
        },
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rental Application',
      home: FutureBuilder(
        future: Provider.of<AuthService>(context).getUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // log error to console
            if (snapshot.error != null) {
              print("error");
              return Text(snapshot.error.toString());
            }
            return snapshot.hasData
                ? snapshot.data.email == 'admin@rental.com'
                    ? HomePage(currentUser: snapshot.data)
                    : UserHome(snapshot.data)
                : LoginPage();
          } else {
            return LoadingCircle();
          }
        },
      ),
    );
  }
}

class LoadingCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.redAccent,
          body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(Icons.home,
                  size: 80.0,
                  color: Colors.white,),
                  SpinKitFadingCircle(
            color: Colors.white,
            size: 50.0,
          ),
          Text('Please Wait',
          style: TextStyle(color: Colors.white,
          fontSize: 25.0),
          ),
                ],
              ))),
    );
  }
}
