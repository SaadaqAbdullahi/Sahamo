//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//define a stateless widget for the progress indicator
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: SpinKitRing(
          color: Colors.green[500],
          size: 50.0,
        )
      ),
    );
  }
}