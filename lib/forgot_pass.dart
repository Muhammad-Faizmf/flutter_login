
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/login_page.dart';
import 'package:login_app/sign_up.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({ Key? key }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _formkey = GlobalKey<FormState>();
  var email = "";

  final emailController = TextEditingController();

  ResetPassword() async {
   try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.orange,
            content: Text(
              "Email Link is send to your Email ID. Check it out.",
                style: TextStyle(
                fontSize: 18,
              ),
          ),
        )
      );
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(
          builder: (context) => LoginPage()
          ), 
        (route) => false
      );
   } on FirebaseAuthException catch (e) {
     if(e.code == "user-not-found"){
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
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[600],
        title: Text("Reset Password"),
      ),
      body: Form(
        key: _formkey,
        child: Container(
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reset Link will be send to your Email ID: ",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),
              ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  errorStyle: TextStyle(
                    fontSize: 13,
                  ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                )
                ),
                validator: (value) {
                  if(value!.isEmpty) {
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () {
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      email = emailController.text;
                    });
                    ResetPassword();
                  }
                }, 
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[600],
                    minimumSize: Size(100, 43)
                  ),
                child: Text("Send Email")
                ),
                SizedBox(width: 10),
                TextButton(onPressed: (){
                   Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(
                      builder: (context) => LoginPage()
                    ), 
                    (route) => false
                    );
                },
                 child: Text(
                   "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                   )
                 ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? "),
                TextButton(onPressed: (){
                   Navigator.pushAndRemoveUntil(
                    context, MaterialPageRoute(
                      builder: (context) => SignupPage()
                        ),
                      (route) => false
                    );
                },
                 child: Text(
                   "Sign up",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14
                      ),
                   )
                 ),
              ],
            ),
          ],
        ),
      )
    )
    );
  }
}