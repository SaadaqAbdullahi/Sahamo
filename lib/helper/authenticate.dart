import 'package:flutter/material.dart';
import 'package:sahamo/views/login.dart';
import 'package:sahamo/views/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool _showSignIn = true;

  void _toggleView(){
    _showSignIn = !_showSignIn;
  }

  @override
  Widget build(BuildContext context) {
    if (_showSignIn){
      return LogIn(_toggleView);
    }
    else{
      return SignUp(_toggleView);
    }
  }
}
