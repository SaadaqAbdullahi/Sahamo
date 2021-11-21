//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/shared_preferences.dart';
import 'package:group_chat_app/views/forgot_password_page.dart';
import 'package:group_chat_app/views/home_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/shared/loading.dart';
import 'package:group_chat_app/widgets/header_container.dart';

class LogIn extends StatefulWidget {
  final Function toggleView;
  LogIn({this.toggleView});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;


  String email = '';
  String password = '';
  String error = '';

  //define a function to log the user in
  _logMeIn() async {

    //check if form is successfully validated
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth
          .signInWithEmailAndPassword(email, password)
          .then((result) async {
            //check if error occurred with signing in
        if (result == "pass")
          setState(() {
            error = 'You have entered an invalid password';
            _isLoading = false;
          });
        else if (result == "user") {
          setState(() {
            error = 'You have entered an invalid email';
            _isLoading = false;
          });
        } else {

          //retrieve user data from the database
          QuerySnapshot userInfoSnapshot =
              await DatabaseService().getUserData(email);

          //set shared variables
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data['fullName']);

          print("Signed In");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });

          //navigate to home page
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    //check if page is loading
    return _isLoading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: <Widget>[
                      HeaderContainer("LOG IN"),
                      Form(
                        key: _formKey,
                        child: Expanded(
                          flex: 1,
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    validator: (val) {
                                      //check to see if email entered is a valid email
                                      return RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val)
                                          ? null
                                          : "Please enter a valid email";
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      prefixIcon: Icon(Icons.email),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Color(0xFF66BB6A),
                                              width: 2.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Color(0xFFFF0889B6),
                                              width: 2.0)),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        email = val;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    validator: (val) {
                                      return val.length < 6
                                          ? 'Password must be at least 6 characters long'
                                          : null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      prefixIcon: Icon(Icons.vpn_key),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Color(0xFF66BB6A),
                                              width: 2.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Color(0xFFFF0889B6),
                                              width: 2.0)),
                                    ),
                                    obscureText: true,
                                    onChanged: (val) {
                                      setState(() {
                                        password = val;
                                      });
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    //navigate to forgot password page
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ForgotPassword()));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 10),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: const Color(0xFF66BB6A),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0,),
                                Text(
                                  error,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _logMeIn();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          const Color(0xFF66BB6A),
                                          const Color(0xFF4CAF50),
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Don't Have an Account? ",
                                        style: TextStyle(
                                            color: const Color(0xFF66BB6A),
                                            fontSize: 16.0)),
                                    TextSpan(
                                      text: "Register Here!",
                                      style: TextStyle(
                                        color: const Color(0xFF66BB6A),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                        //navigate to sign up page
                                          widget.toggleView();
                                        },
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
