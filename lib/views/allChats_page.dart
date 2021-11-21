//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/shared_preferences.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/group_tile.dart';
import 'package:group_chat_app/widgets/app_bar.dart';

class AllChats extends StatefulWidget {
  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {

  //define the necessary variable
  FirebaseUser _user;
  String _groupName;
  Stream _groups;

  @override

  //initiate state
  void initState() {
    super.initState();
    //call the get user authentication and join groups function
    _getUserAuthAndJoinedGroups();
  }

  //define a widget to display when a user isn't participating to no group chat
  Widget noGroup() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                //call the pop up dialog function later defined in this file
                _popupDialog(context);
              },
              child: Icon(Icons.sentiment_very_dissatisfied,
                  color: Color(0xFF66BB6A), size: 75.0),),
            SizedBox(height: 20.0),
            Text(
              "You haven't joined a group yet!",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Tap on the 'add' icon to create a group or search for groups by tapping on the search button below.",
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  //define a widget to display all the groups a specific user is participating in
  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        //check if the snapshot has data
        if (snapshot.hasData) {
          //check if the snapshot has groups
          if (snapshot.data['groups'] != null) {
            //check if the groups in the snapshot are not empty
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reqIndex = snapshot.data['groups'].length - index - 1;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 0.5,
                              color: Colors.green[500]),
                        ),
                      ),
                      child: GroupTile(
                          userName: snapshot.data['fullName'],
                          groupId:
                          _sliceId(snapshot.data['groups'][reqIndex]),
                          groupName: _sliceName(
                              snapshot.data['groups'][reqIndex])),
                    );
                  });
            } else {
              return noGroup();
            }
          } else {
            return noGroup();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  //define a function to retrieve the user authentication and joined groups
  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser();
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      setState(() {
        //save the snapshot of all the groups a user is participating
        _groups = snapshots;
      });
    });
  }

  //define a function to slice the id of a group or a user
  String _sliceId(String res) {
    return res.substring(0, res.indexOf('_'));
  }

  //define a function to slice the name of a group or a user
  String _sliceName(String res) {
    return res.substring(res.indexOf('_') + 1);
  }

  //define a pop up dialog to allow user to create a group chat
  void _popupDialog(BuildContext context) {

    //define a cancel button widget
    Widget cancelButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[500]),
      ),
      child: Text("Cancel"),
      onPressed: () {
        //go to previous page
        Navigator.of(context).pop();
      },
    );

    //define a create button widget
    Widget createButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green[500]),
      ),
      child: Text("Create"),
      onPressed: () async {
        //check if the group name entered is not empty
        if (_groupName != null) {
          //retrieve the user name of the user from the shared preferences
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            //create the group in the database
            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });
          //go to previous page
          Navigator.of(context).pop();
        }
      },
    );

    //create an alert dialog
    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
          onChanged: (val) {
            //save group name value the user entered
            _groupName = val;
          },
          style: TextStyle(fontSize: 17.0, height: 2.0,)),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    //show the alert dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(context, "My Chats"),
      //show group list in the body
      body: groupsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
        },
        child: Icon(Icons.add, color: Colors.white, size: 30.0),
        backgroundColor: Colors.green[500],
        elevation: 0.0,
      ),
    );
  }
}
