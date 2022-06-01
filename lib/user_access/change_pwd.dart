// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/login_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({ Key? key }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

  final _formkey = GlobalKey<FormState>();
  var newpassword;
  var confirm_password;

  final pass_Controller = TextEditingController();
  final confpass_controller = TextEditingController();

  final current_user = FirebaseAuth.instance.currentUser;

  ChangePassword() async {
    try {
      await current_user!.updatePassword(newpassword);
      FirebaseAuth.instance.signOut();
       Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
          builder: (context) => LoginPage()
        ),
       (route) => false
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Your Password has been Changed, Please Login again.',
            style: TextStyle(
              fontSize: 20.0
            ),
            )
        )
      );
    } on FirebaseAuthException catch (e) {
      if(e.code == 'weak-newpassword'){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password is too Weak.',
            style: TextStyle(
              fontSize: 20.0
            ),
            )
        )
      );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      child: Column(
        children: [ 
          Form(
            key: _formkey,
            child: TextFormField(
              obscureText: true,
              controller: pass_Controller,
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter a New Password',
                border: OutlineInputBorder()
              ),
              validator: (value){
                if(value!.isEmpty){
                  return 'Please Enter a New Password';
                }
                else if(value.length < 8){
                  return "Password length must be 8";
                }
                return null;
              }
            )   
          ),
          SizedBox(height: 15),
         Container(
           margin: EdgeInsets.symmetric(vertical: 10),
           child:  ElevatedButton(onPressed: (){
             if(_formkey.currentState!.validate()){
               setState(() {
                 newpassword = pass_Controller.text;
                 confirm_password = confpass_controller.text;
               });
               ChangePassword();
             }
           },
           style: ElevatedButton.styleFrom(
             minimumSize: Size(400,40),
             primary: Colors.grey[600]
           ),
           child: Text('Change Password')
           ),
         ),
        ]
      )
    );
  }
}