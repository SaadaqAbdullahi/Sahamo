//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {

  final String message;
  final String sender;
  final String time;
  final bool sentByMe;

  MessageTile({this.message, this.sender, this.sentByMe, this.time});

  _formatDate(String datetime) {
    int timeInMillis = int.parse(datetime);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    String formattedDate = DateFormat("MMM d yyyy h:mma").format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        //if message was sent by user, show on right side of screen. Else show on the left
        left: sentByMe ? 0 : 24,
        right: sentByMe ? 24 : 0),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          //style the chat bubble differently for sent by user or sent by others
          margin: sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
          borderRadius: sentByMe ? BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          )
          :
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)
          ),
          color: sentByMe ? Colors.green[500] : Colors.grey[600],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(sender.toUpperCase(), textAlign: TextAlign.start, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -0.5)),
              SizedBox(height: 7.0),
              Text(message, textAlign: TextAlign.start, style: TextStyle(fontSize: 15.0, color: Colors.white)),
              SizedBox(height: 5.0),
              Text(_formatDate(time), textAlign: TextAlign.start, style: TextStyle(fontSize: 12.0, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}