//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:cloud_firestore/cloud_firestore.dart';

//create a database class with essential database methods
class DatabaseService {
  final String uid;

  //constructor with user id as a parameter
  DatabaseService({this.uid});

  //create variables with collection references
  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference groupCollection =
      Firestore.instance.collection('groups');

  //define a function to update user data in the database
  Future updateUserData(String fullName, String email, String password) async {
    //setting fields in the database with new values with the following user id
    return await userCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': ''
    });
  }

  //define a function create a new group in the database
  Future createGroup(String userName, String groupName) async {
    //add all the values to the fields present in the database within the group collection
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'admin': userName,
      'members': [],
      //'messages': ,
      'groupId': '',
      'recentMessage': '',
      'recentMessageSender': ''
    });

    await groupDocRef.updateData({
      //add the newly added users the specified group
      'members': FieldValue.arrayUnion([uid + '_' + userName]),
      'groupId': groupDocRef.documentID
    });

    //create a user document reference
    DocumentReference userDocRef = userCollection.document(uid);
    return await userDocRef.updateData({
      //add newly added group data to the user collection
      'groups':
          FieldValue.arrayUnion([groupDocRef.documentID + '_' + groupName])
    });
  }

  //define a function to toggle between group joining and group leaving in the search page
  Future togglingGroupJoin(
      String groupId, String groupName, String userName) async {
    //create user document reference variable
    DocumentReference userDocRef = userCollection.document(uid);

    //create a user document snapshot variable
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    //create a group document reference variable
    DocumentReference groupDocRef = groupCollection.document(groupId);

    //create a list of all the groups present in the database
    List<dynamic> groups = await userDocSnapshot.data['groups'];

    //check for groups containing a specific group name and group id
    if (groups.contains(groupId + '_' + groupName)) {
      //remove group info to the user document
      await userDocRef.updateData({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      //remove user info to the group document
      await groupDocRef.updateData({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
    } else {
      //add group info to the user document
      await userDocRef.updateData({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      //add user info to the group document
      await groupDocRef.updateData({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }

  //define a function to check if a specific user is present in a group
  Future<bool> isUserJoined(
      String groupId, String groupName, String userName) async {
    //creating user doc reference variable and user snapshot variable
    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    //create a list of all groups the user is participating in
    List<dynamic> groups = await userDocSnapshot.data['groups'];

    //check if specified group is among the list of groups the user is participating in
    if (groups.contains(groupId + '_' + groupName)) {
      return true;
    } else {
      return false;
    }
  }

  //define a function that retrieves user data of a specified email
  Future getUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where('email', isEqualTo: email).getDocuments();
    print(snapshot.documents[0].data);
    return snapshot;
  }

  //define a function to get user groups
  getUserGroups() async {
    return Firestore.instance.collection("users").document(uid).snapshots();
  }

  //define a function to allow user to send a message
  sendMessage(String groupId, chatMessageData) {
    //add message in specified collection
    Firestore.instance
        .collection('groups')
        .document(groupId)
        .collection('messages')
        .add(chatMessageData);

    //set chat message values to database fields
    Firestore.instance.collection('groups').document(groupId).updateData({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

  //define a function to retrieve all the messages of a specific group
  getChats(String groupId) async {
    return Firestore.instance
        .collection('groups')
        .document(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  //define a function to search for specific group name in the database
  searchByName(String groupName) {
    return Firestore.instance
        .collection("groups")
        .where('groupName', isEqualTo: groupName)
        .getDocuments();
  }

  leaveGroup(String groupId, String groupName, String userName) async {
    //create user document reference variable
    DocumentReference userDocRef = userCollection.document(uid);

    //create a group document reference variable
    DocumentReference groupDocRef = groupCollection.document(groupId);

    await userDocRef.updateData({
      'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
    });

    //remove user info to the group document
    await groupDocRef.updateData({
      'members': FieldValue.arrayRemove([uid + '_' + userName])
    });
  }

  storeUserKey(String uKey) async{
    return await userCollection.document(uid).setData({
      'key': uKey,
    });
  }
}
