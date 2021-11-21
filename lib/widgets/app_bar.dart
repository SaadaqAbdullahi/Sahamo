//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:flutter/material.dart';

//define app bar widget used repetitively in various pages
Widget MainAppBar(BuildContext context, String text) {
  return AppBar(
    title: Text(text, style: TextStyle(color: Colors.white, fontSize: 27.0, fontWeight: FontWeight.bold)),
    backgroundColor: Colors.green[500],
    elevation: 0.0,
  );
}