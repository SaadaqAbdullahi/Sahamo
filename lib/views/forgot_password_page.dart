//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:flutter/material.dart';
import 'package:group_chat_app/widgets/header_container.dart';
import 'package:group_chat_app/services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final AuthService _auth = AuthService();
  String email = "";
  String error = "";
  String result = "";
  final _formKey = GlobalKey<FormState>();

  //define a function to send an password reset email to a particular email
  Future _sendEmail() async {
    if (_formKey.currentState.validate()) {
       await _auth.sendPasswordResetEmail(email).then((result) {
         //check to see if an error was found
        if (result == "email") {
          setState(() {
            error = "The email you entered doesn't exist";
          });
        }
        else{
          setState(() {
            //show the reset password dialog pop up
            _resetPasswordDialog(context);
          });
        }
      });
    }
  }

  @override

  //define a function to return a reset password dialog box
  void _resetPasswordDialog(BuildContext context) {
    Widget okButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[500]),
      ),
      child: Text("OK"),
      onPressed: () {
        //return to the previous log in page
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Password Reset Email Sent!"),
      content: Text(
        "A password reset email was sent to $email. Please check your email and follow the instruction to reset your password.",
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              title: new Text(
                "",
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //return a header container widget defined in a separate file
                      HeaderContainer("Reset Password"),
                      Form(
                        key: _formKey,
                        child: Expanded(
                          flex: 1,
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 30),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 10),
                                  child: TextFormField(
                                    validator: (val) {
                                      //check to see if the email entered is a valid email with regular expressions
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
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  //show the error message if applicable
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
                                    _sendEmail();
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
                                      "Send Email",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
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
          ),
        ],
      ),
    );
  }
}
