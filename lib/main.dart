//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/shared_preferences.dart';
import 'package:group_chat_app/views/home_page.dart';
import 'package:group_chat_app/views/welcome_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _getUserLoggedInStatus();
  }

  //define a function to retrieve user shared preference info
  _getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if(value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Chats',
      debugShowCheckedModeBanner: false,
      //define light and dark mode themes
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      //if a user is already logged in go to home page, else go to welcome screen
      home: _isLoggedIn ? HomePage() : WelcomeScreen(),
    );
  }
}
