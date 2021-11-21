import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  retrieveByUsername(String username){

  }
  storeUser(userMap){
    FirebaseFirestore.instance.collection("users").add(userMap);
  }
}