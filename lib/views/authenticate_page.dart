//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:flutter/material.dart';
import 'package:group_chat_app/views/signup_page.dart';
import 'package:group_chat_app/views/login_page.dart';

class AuthenticatePage extends StatefulWidget {
  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {

  bool _showSignIn = true;

  //define function to toggle between log in and sign up pages
  void _toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    //show log in page
    if(_showSignIn) {
      return LogIn(toggleView: _toggleView);
    }
    //show sign up page
    else {
      return SignUp(toggleView: _toggleView);
    }
  }
}