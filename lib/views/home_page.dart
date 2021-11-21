//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/shared_preferences.dart';
import 'package:group_chat_app/views/allChats_page.dart';
import 'package:group_chat_app/views/profile_page.dart';
import 'package:group_chat_app/views/search_page.dart';
import 'package:group_chat_app/services/auth_service.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AuthService _auth = AuthService();
  FirebaseUser _user;
  String _userName = '';
  String _email = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUserAuth();
  }


  //define a function to get user authentication info
  _getUserAuth() async {
    _user = await FirebaseAuth.instance.currentUser();
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    //create a list of all the pages used in the bottom navigation bar widget
    final List<Widget> _children = [
      AllChats(),
      SearchPage(),
      ProfilePage(userName: _userName, email: _email,),
    ];
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.green[500],
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.white,
        onTap: (val) {
          setState(() {
            _selectedIndex = val;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "My Profile"),
        ],
      ),
    );
  }
}

