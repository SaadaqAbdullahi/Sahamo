//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/message_tile.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String userName;
  final String groupName;

  //constructor that accepts the various essential values
  ChatPage({this.groupId, this.userName, this.groupName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  FirebaseUser _user;
  //create a stream of all chat snapshot
  Stream<QuerySnapshot> _chats;

  //create a message editor controller to save value of a text input box
  TextEditingController messageEditingController = new TextEditingController();

  //define a widget to show chat messages in a specific group chat
  Widget _chatMessages() {
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot) {
        //if snapshot has data, create a list view of all the messages
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  //return function to show each message in a specific style specified in a different dart file
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    sender: snapshot.data.documents[index].data["sender"],
                    sentByMe: widget.userName ==
                        snapshot.data.documents[index].data["sender"],
                    time:
                        snapshot.data.documents[index].data["time"].toString(),
                  );
                })
            : Container();
      },
    );
  }

  //function to get current user id
  _getUserid() async{
    _user = await FirebaseAuth.instance.currentUser();
  }

  //define a function to send a message
  _sendMessage() {
    //check if message input box is not empty
    if (messageEditingController.text.isNotEmpty) {
      //create a list of key value pairs relevant to a message
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      //save relevant message data to the database
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        //reset text input box
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //get messages of a specific chat
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        //save messages to a variable used in the above widgets
        _chats = val;
      });
    });
    _getUserid();
  }

  //define a function to return a leave group chat pop up dialog
  void _leaveDialog(BuildContext context) {
    Widget cancelButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[500]),
      ),
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget leaveButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[500]),
      ),
      child: Text("Leave Group"),
      onPressed: () async {
        //sign user out
        await DatabaseService(uid: _user.uid).leaveGroup(widget.groupId, widget.groupName, widget.userName);
        //navigate to welcome screen
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Leaving Group Chat"),
      content: Text("Are you sure you want to leave the group chat?",
          style: TextStyle(
            fontSize: 17.0,
            height: 2.0,
          )),
      actions: [
        cancelButton,
        leaveButton,
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
      appBar: AppBar(
        title: Text(widget.groupName, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green[500],
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              icon: Icon(Icons.exit_to_app, color: Colors.white, size: 25.0),
              onPressed: () {
                _leaveDialog(context);
              })
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _chatMessages(),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.green[300],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageEditingController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Send a message ...",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            border: InputBorder.none),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.green[500],
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                            child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
