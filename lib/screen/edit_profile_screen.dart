import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EditProfile extends StatefulWidget{
  final GoogleSignInAccount? user;
  EditProfile({super.key, required this.user});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        ],
      ),
    );
  }
}
