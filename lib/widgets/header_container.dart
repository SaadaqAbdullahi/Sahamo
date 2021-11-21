//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:flutter/material.dart';

class HeaderContainer extends StatelessWidget {
  var text = "Login";

  HeaderContainer(this.text);

  @override
  Widget build(BuildContext context) {
    //return container of log in/registration page header style
    return Container(
      height: MediaQuery.of(context).size.height / 2.6,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xFF66BB6A),
            const Color(0xFF4CAF50),
          ], end: Alignment.bottomCenter, begin: Alignment.topCenter),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100))),
      child: Stack(
        children: <Widget>[
          Positioned(
              bottom: 20,
              right: 20,
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic),
              )),
          Center(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/sahamo_print.png",
                      height: 50.0,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Image.asset(
                      "assets/images/logo.png",
                      height: 75.0,
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
