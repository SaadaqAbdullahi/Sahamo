//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:flutter/material.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/views/welcome_page.dart';
import 'package:group_chat_app/widgets/app_bar.dart';

class ProfilePage extends StatelessWidget {

  final String userName;
  final String email;
  final AuthService _auth = AuthService();

  ProfilePage({this.userName, this.email});

  //define a function to return a log out pop up dialog
  void _popupDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[500]),
      ),
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget logOutButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[500]),
      ),
      child: Text("Log Out"),
      onPressed: () async {
        //sign user out
        await _auth.signOut();
        //navigate to welcome screen
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (Route<dynamic> route) => false);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Logging Out"),
      content: Text("Are you sure you want to log out?",
          style: TextStyle(
            fontSize: 17.0,
            height: 2.0,
          )),
      actions: [
        cancelButton,
        logOutButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(context, "My Profile"),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 130.0),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.account_circle, size: 200.0, color: Colors.grey[700]),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Full Name', style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold)),
                    Text(userName, style: TextStyle(fontSize: 17.0)),
                  ],
                ),

                Divider(height: 20.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Email', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                    Text(email, style: TextStyle(fontSize: 17.0)),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                    _popupDialog(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.exit_to_app, size: 50,),
                        Text(
                          "Log Out",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}