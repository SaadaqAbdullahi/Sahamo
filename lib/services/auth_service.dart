//Authored by: Saadaq Abdullahi
//Last modified: May 12, 2021

import 'package:firebase_auth/firebase_auth.dart';
import 'package:group_chat_app/helper/shared_preferences.dart';
import 'package:group_chat_app/models/user.dart';
import 'package:group_chat_app/services/database_service.dart';

//User authentication class with essential authentication functions
class AuthService {

  //create a firebase authentication object with the necessary methods
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    //ternary operator to make sure user is not null
    return (user != null) ? User(uid: user.uid) : null;
  }

  //define a function for sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      //create a result variable of the user sign in
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      //if the user entered a wrong password, return a string for error purposes
      if (e.code.toString() == "ERROR_WRONG_PASSWORD") {
        return "pass";
        //if the user entered a wrong email, return a string for error purposes
      } else if (e.code.toString() == "ERROR_USER_NOT_FOUND") {
        return "user";
      }
      return null;
    }
  }

  //define a function to register user with email and password
  Future registerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      //create a result variable of the user registration
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //create a new document for the user with uid
      await DatabaseService(uid: user.uid)
          .updateUserData(fullName, email, password);
      return _userFromFirebaseUser(user);
    } catch (e) {
      //if the user entered an email that already exist, return a string for error purposes
      if (e.code.toString() == "ERROR_EMAIL_ALREADY_IN_USE") {
        return "used";
      }
      return null;
    }
  }

  //define a sign out function
  Future signOut() async {
    try {
      //clearing all shared preferences, to avoid saved data when app is closed
      await HelperFunctions.saveUserLoggedInSharedPreference(false);
      await HelperFunctions.saveUserEmailSharedPreference('');
      await HelperFunctions.saveUserNameSharedPreference('');

      //after signing out, get cleared shared preferences for debugging purposes
      return await _auth.signOut().whenComplete(() async {
        //verifying if user is logged out with simple print statements to the console
        await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
          print("Logged in: $value");
        });
        await HelperFunctions.getUserEmailSharedPreference().then((value) {
          print("Email: $value");
        });
        await HelperFunctions.getUserNameSharedPreference().then((value) {
          print("Full Name: $value");
        });
      });
    } catch (e) {
      //print error message if applicable
      print(e.toString());
      return null;
    }
  }

  //define a function for password reset
  sendPasswordResetEmail(String email) {
    try {
      //send an email with password reset capabilities
      return _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      //if the user entered an email that doesn't exist, return a string for error purposes
      if (e.code.toString() == "ERROR_USER_NOT_FOUND") {
        return "email";
      }
      return null;
    }
  }
}
