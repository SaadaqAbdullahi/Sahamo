import 'package:flutter/material.dart';

Widget mainAppBar(BuildContext context) {
  return AppBar(
    title: Image.asset("assets/images/sahamo_print.png",
    height: 50,
    ),
  );
}
InputDecoration textFieldDecoration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

TextStyle textFieldStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}

TextStyle textFieldStyle2() {
  return TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}

