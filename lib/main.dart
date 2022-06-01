// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_app/login_page.dart';
import 'package:login_app/user_access/user_main.dart';

void main(List<String> args){
   WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({ Key? key }) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final storage = new FlutterSecureStorage();

  Future<bool> CheckLoginStatus() async {
    String? value = await storage.read(key: "uid");
    if(value == null){
      return false;
    }
    else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if(snapshot.hasError){
          print("Something Went Wrong");
        }
        else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return MaterialApp(
          title: "Login",
          theme: ThemeData(
            primaryColor: Colors.blue
          ),
          debugShowCheckedModeBanner: false,
          home: FutureBuilder(
            future: CheckLoginStatus(),
            builder: 
            (BuildContext context, AsyncSnapshot<bool> snapshot){
              if(snapshot.data == false){
                return LoginPage();
              }
              else if(snapshot.connectionState == ConnectionState.waiting){
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator()));
              }
              return UserMain();
            }
            ),
        );
      }, 
    );
  }
}

