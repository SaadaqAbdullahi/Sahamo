//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/shared_preferences.dart';
import 'package:group_chat_app/views/home_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/shared/loading.dart';
import 'package:group_chat_app/widgets/header_container.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String fullName = '';
  String email = '';
  String password = '';
  String error = '';

  //define a function to save the user information in the database
  _registerMe() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth
          .registerWithEmailAndPassword(fullName, email, password)
          .then((result) async {
            //check for errors in registering user
        if (result == "used") {
          setState(() {
            error = 'The email you entered is already in use';
            _isLoading = false;
          });
        } else {
          //save all user shared preferences
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(fullName);

          //navigate to home page after completion of registration
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      HeaderContainer("REGISTER"),
                      Form(
                        key: _formKey,
                        child: Expanded(
                          flex: 1,
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    validator: (val) {
                                      //check for empty name
                                      return (val).length < 1
                                          ? "Please enter your name"
                                          : null;
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Full Name",
                                      prefixIcon: Icon(Icons.person),
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
                                        fullName = val;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    validator: (val) {
                                      //check for valid email using regular expressions
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
                                      //check to see if password meets acceptable length
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
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  //show error if applicable
                                  error,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                GestureDetector(
                                  onTap: () {
                                    //call function upon tap of submit button
                                    _registerMe();
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
                                      "Sign Up",
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
                                        text: "Already Have an Account? ",
                                        style: TextStyle(
                                            color: const Color(0xFF66BB6A),
                                            fontSize: 16.0)),
                                    TextSpan(
                                      text: "Log In Here!",
                                      style: TextStyle(
                                        color: const Color(0xFF66BB6A),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                        //navigate to log in page
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
