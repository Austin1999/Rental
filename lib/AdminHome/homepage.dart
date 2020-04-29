import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rental_prototype/AdminHome/place.dart';
import 'package:rental_prototype/dashboard/dashboard.dart';
import 'package:rental_prototype/dashboard/profilepage.dart';
import 'messages/chat_main.dart';

class HomePage extends StatefulWidget {
   final FirebaseUser currentUser;
    HomePage({this.currentUser});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    PlacePage(),
    ChatHomeScreen(),
    Dashboard(),
    ProfilePage(),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: 
      _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
              color: Colors.black,),
              title: Text("Home",
              style: TextStyle(
                color: Colors.black38
              ),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat,
              color: Colors.black,),
              title: Text("Messages",
              style: TextStyle(
                color: Colors.black38
              ),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard,
              color: Colors.black,),
              title: Text("DashBoard",
              style: TextStyle(
                color: Colors.black38
              ),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,
              color: Colors.black,),
              title: Text("Profile",
              style: TextStyle(
                color: Colors.black38
              ),),
            ),
          ]
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}