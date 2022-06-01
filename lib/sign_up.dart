
// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/login_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({ Key? key }) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final _formkey = GlobalKey<FormState>();

  var email = "";
  var password = "";
  var confirm_password = "";

  // for password only
  bool _obscureText = true;
  
  // for confirm password only
  bool _obscuretext = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confm_passswordController = TextEditingController();

  Future CreateUserAccounts() async {
    try {
      UserCredential usercredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.orange,
          content: Text(
            "Account created successfully. Please Login.",
            style: TextStyle(
              fontSize: 18
            ),
          )
          ),
      );
      Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(
          builder: (context) => LoginPage()
          ), 
        (route) => false
      );
    } on FirebaseAuthException catch (e) {
      if(e.code == "email-already-in-use"){
        emailController.clear();
        passwordController.clear();
        confm_passswordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.red,
            content: Text(
              "Email already exists. Try another one.",
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
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formkey,
          child: SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 100),
                  child: 
                    Center(
                      child: Text(
                        "Create an Account",
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
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      hintText: "Email",
                      prefixIcon: Icon(Icons.person, color: Colors.black45),
                      errorStyle: TextStyle(
                      fontSize: 13,
                    ),
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
                  }
                ),
                SizedBox(height: 15),
                TextFormField(
                 obscureText: _obscureText,
                 controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    hintText: "Password",
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility
                        ),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.black45),
                    errorStyle: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if(value!.isEmpty){
                      return "Please enter password";
                    }
                    else if(value.length < 8){
                      return "Password is too weak";
                    }
                  },
                ),
                SizedBox(height: 15),
                 TextFormField(
                  obscureText: _obscuretext,
                  controller: confm_passswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    hintText: "Confirm Password",
                    suffixIcon: IconButton(
                      onPressed: (){
                        setState(() {
                          _obscuretext = !_obscuretext;
                        });
                      },
                      icon: Icon(
                        _obscuretext ? Icons.visibility_off : Icons.visibility
                        ),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.black45),
                    errorStyle: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  validator: (value) {
                    if(value!.isEmpty){
                      return "Please enter confirm password";
                    }
                    else if(value.length < 8){
                      return "Confirm password is too weak";
                    }
                    else if(value != passwordController.text){
                      passwordController.clear();
                      confm_passswordController.clear();
                      return "Passwords not matched";
                    }
                    return null;
                  },
                ),
                ])
                ),
                SizedBox(height: 15),
                Container(
                margin: EdgeInsets.symmetric( horizontal: 30),
                child: ElevatedButton(onPressed: () {
                  if(_formkey.currentState!.validate()){
                    setState(() {
                      email = emailController.text;
                      password = passwordController.text;
                      confirm_password = confm_passswordController.text;
                    });
                    CreateUserAccounts(); 
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[600],
                  minimumSize: Size(30, 43)
                ),
                  child: Center(child: Text("Sign Up")),
                )
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(),
                    child: Text(
                      "Already have an account!",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      ),
                  ),
                  TextButton(
                    onPressed: (){
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
                        color: Colors.black
                      ),
                      ),
                  )
                ],
              ),
              ],
            ),
          ),
        ))
    );
  }
}