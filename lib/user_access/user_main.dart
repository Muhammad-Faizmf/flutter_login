
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_app/login_page.dart';
import 'package:login_app/user_access/change_pwd.dart';
import 'package:login_app/user_access/user_profile.dart';

class UserMain extends StatefulWidget {
  const UserMain({ Key? key }) : super(key: key);

  @override
  _UserMainState createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {

  int selectedIndex = 0;

 

  static List<Widget> WidgetOptions = <Widget>[
    Center(
      child: Text("Dashboard")
    ),
    Center(
      child: UserProfile()
    ),
   Center(
      child: ChangePassword(),
    ),
  ];

  _tapItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }


  // Logging out a user
  Logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(
        builder: (context) => LoginPage()
        ),
       (route) => false
      );
  }
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Welcome Back"),
              ElevatedButton(
                onPressed: () async {
                  Logout();
                  await storage.delete(key: "uid");
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.indigo
                ),
                child: Text("Logout"),
              )
            ],
          ),
        ),
        body: WidgetOptions.elementAt(selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "My Profile",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
          onTap: _tapItem,
          selectedItemColor: Colors.lightBlueAccent,
        ),
      )
    );
  }
}