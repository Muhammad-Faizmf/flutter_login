
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_app/forgot_pass.dart';
import 'package:login_app/sign_up.dart';
import 'package:login_app/user_access/user_main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final formkey = GlobalKey<FormState>();
  var email = "";
  var password = "";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _showtext = true;

  final storage = new FlutterSecureStorage();
  
  // Connectivity checking for wifi and mobile data
  
  CheckInternetConnection() async {

    var connectivityResult = await (Connectivity().checkConnectivity());

    if(connectivityResult == ConnectivityResult.wifi ||
    connectivityResult == ConnectivityResult.mobile) {
      UserLogin();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.red,
            content: Text(
              "No internet connection",
                style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        );
        emailController.clear();
        passwordController.clear();
    }
    setState(() {});
  }

  // Logging a user
  GetLogin(){
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(
        builder: (context) => UserMain()
        ),
       (route) => false
      );
  }

  // Check Legitimate Accounts
  UserLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password
      );
      await storage.write(key: "uid", value: userCredential.user!.uid);
      GetLogin();
      
    } on FirebaseAuthException catch (e) {
      if(e.code == "user-not-found"){
        passwordController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.red,
            content: Text(
              "No User Found.",
                style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        );
      }
      if(e.code == "wrong-password"){
        passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: Colors.red,
            content: Text(
              "Invalid Password.",
                style: TextStyle(
                fontSize: 18,
              ),
            ),
          )
        );
      }
    }
  }

  // Jumping to sign up page
  GoToSignup(){
    Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(
        builder: (context) => SignupPage()),
       (route) => false
      );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Form( 
            key: formkey,
            child: SingleChildScrollView(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 100),
                  child: 
                    Center(
                      child: Text(
                        "LOGIFY",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                  )),
                  SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 30,
                    right: 30,
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      errorStyle: TextStyle(
                      fontSize: 13,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please enter email";
                    }
                    else if(!value.contains("@gmail.com")){
                      return "Invalid Email";
                    }
                    else if(!value.endsWith(".com")){
                      return "Invalid Email";
                    }
                    else if(value.length < 11){
                      return "Email not Found";
                    }
                    else if(!value.startsWith(RegExp('[a-z]'))){
                      return "Not Appropriate Email";
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 30,
                  right: 30,
                ),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _showtext,
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      highlightColor: Colors.transparent,
                      icon: Icon(
                        _showtext ? Icons.visibility_off : Icons.visibility
                        ),
                      onPressed: () {
                        setState(() {
                          _showtext = !_showtext;
                        });
                      },
                    ),
                    errorStyle: TextStyle(
                      fontSize: 13,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                  validator: (value) {
                    if(value!.isEmpty){
                      return "Please enter password";
                    }
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 220),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(
                        builder: (context) => ForgotPassword()
                        ),
                       (route) => false
                      );
                  },
                  child: Text(
                    "Forgot Password",
                    style: TextStyle(
                      color: Colors.black
                    ),
                    ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric( horizontal: 30),
                child: ElevatedButton(onPressed: () {
                  if(formkey.currentState!.validate()){
                    setState(() {
                      email = emailController.text;
                      password = passwordController.text;
                    });
                    CheckInternetConnection();
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[600],
                  minimumSize: Size(30, 43)
                ),
                  child: Center(child: Text("Login")),
                )
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Create an account!",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    ),
                  TextButton(onPressed: () {
                    GoToSignup();
                  },
                   child: Text(
                     "Sign up",
                     style: TextStyle(color: Colors.black),
                     )
                  )
                ],
              ),
              )
            ],
          )
        ),
      )
      ),
      );
  }
}