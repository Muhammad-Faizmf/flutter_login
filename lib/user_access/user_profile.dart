
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class UserProfile extends StatefulWidget {
  const UserProfile({ Key? key }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final userid = FirebaseAuth.instance.currentUser!.uid;
  final userid_date = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "UserID: $userid",
            style: TextStyle(
              fontSize: 15.0
            ),
            ),
          Text(
            "Created at: $userid_date",
            style: TextStyle(
              fontSize: 15.0
            ),
            ),
          
        ],
      )
    );
  }
}