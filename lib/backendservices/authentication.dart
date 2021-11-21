import 'package:firebase_auth/firebase_auth.dart';
import 'package:sahamo/model/user.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FbUser _firebaseUser(User user) {
    if (user != null) {
      return FbUser(userId: user.uid);
    } else {
      return null;
    }
  }

  Future logInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword
        (email: email, password: password);
      User firebaseUser = result.user;
      return _firebaseUser(firebaseUser);
    }
    catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword
        (email: email, password: password);
      User firebaseUser = result.user;
      return _firebaseUser(firebaseUser);
    }
    catch(e){
      print(e.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }
}