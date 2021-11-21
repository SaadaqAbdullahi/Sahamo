//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/shared_preferences.dart';
import 'package:group_chat_app/views/groupchat_page.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/app_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  //define the necessary variables
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String _userName = '';
  FirebaseUser _user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // initState()
  @override
  void initState() {
    super.initState();
    _getCurrentUserNameAndUid();
  }

  //define function to retrieve current user name and user id
  _getCurrentUserNameAndUid() async {
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      _userName = value;
    });
    _user = await FirebaseAuth.instance.currentUser();
  }

  //define function to begin group name search
  _initiateSearch() async {
    //check if search text field is not empty
    if (searchEditingController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      //retrieve snapshot of group name search snapshot
      await DatabaseService()
          .searchByName(searchEditingController.text)
          .then((snapshot) {
        searchResultSnapshot = snapshot;
        setState(() {
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  //define function to show pop up snack bar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green[200],
      duration: Duration(milliseconds: 1500),
      content: Text(message,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0)),
    ));
  }

  //define function to check if a user has already joined a group
  _isJoinedInGroup(
      String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseService(uid: _user.uid)
        .isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }

  //define a group list widget to show searched group info
  Widget groupList() {
    //check if user searched a group
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.documents.length,
            itemBuilder: (context, index) {
              return groupTile(
                _userName,
                searchResultSnapshot.documents[index].data["groupId"],
                searchResultSnapshot.documents[index].data["groupName"],
                searchResultSnapshot.documents[index].data["admin"],
              );
            })
        : Container();
  }

  //define a group tile widget to show the necessary info about group searched in a styled manner
  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    _isJoinedInGroup(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: Colors.green[500],
          child: Text(groupName.substring(0, 1).toUpperCase(),
              style: TextStyle(color: Colors.white))),
      title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("Admin: $admin"),
      trailing: InkWell(
        onTap: () async {
          //toggle between group joined or not, save its status in the database
          await DatabaseService(uid: _user.uid)
              .togglingGroupJoin(groupId, groupName, userName);
          if (_isJoined) {
            setState(() {
              _isJoined = !_isJoined;
            });
            _showSnackBar('Successfully joined the group "$groupName"');
            //navigate to chat page after a specific period of time
            Future.delayed(Duration(milliseconds: 2000), () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(
                      groupId: groupId,
                      userName: userName,
                      groupName: groupName)));
            });
          } else {
            setState(() {
              _isJoined = !_isJoined;
            });
            _showSnackBar('Left the group "$groupName"');
          }
        },
        //depending on if user has joined a group, style touch box accordingly
        child: _isJoined
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueAccent,
                    border: Border.all(color: Colors.white, width: 1.0)),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Joined', style: TextStyle(color: Colors.white)),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.green[500],
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text('Join', style: TextStyle(color: Colors.white)),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: MainAppBar(context, "Search"),
      body: isLoading
          //if page is loading show progress indicator spinning
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          //else show the search input box and groups searched
          : Container(
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    color: Colors.grey[700],
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                hintText: "Search groups...",
                                hintStyle: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              _initiateSearch();
                            },
                            child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.green[500],
                                    borderRadius: BorderRadius.circular(40)),
                                child: Icon(Icons.search, color: Colors.white)))
                      ],
                    ),
                  ),
                  isLoading
                      ? Container(
                          child: Center(child: CircularProgressIndicator()))
                      : groupList()
                ],
              ),
            ),
    );
  }
}
