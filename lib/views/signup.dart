import 'package:flutter/material.dart';
import 'package:sahamo/backendservices/authentication.dart';
import 'package:sahamo/backendservices/database.dart';
import 'package:sahamo/views/allchats.dart';
import 'package:sahamo/widgets/widget.dart';

class SignUp extends StatefulWidget {

  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  TextEditingController usernameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  Authentication authMethods = new Authentication();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  signMeUp() {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      authMethods.signUpWithEmailAndPassword(emailTextController.text,
          passwordTextController.text).then((val) {

            Map<String, String> userInfoMap = {
              "name" : usernameTextController.text,
              "email" : emailTextController.text
            };
            databaseMethods.storeUser(userInfoMap);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => AllChats()
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ):
      SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val){
                          if(val.isEmpty){
                            return "Please enter username!";
                          }
                          else if(val.length < 4){
                            return "Username must be at least 4 characters long!";
                          }
                          return null;
                        },
                        controller: usernameTextController,
                        style: textFieldStyle(),
                        decoration: textFieldDecoration("Username"),
                      ),
                      TextFormField(
                        validator: (val){
                          if(val.isEmpty){
                            return "Please enter an email address!";
                          }
                          if(RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(val)){
                            return null;
                          }
                          return "Please enter a correct email address!";
                        },
                        controller: emailTextController,
                        style: textFieldStyle(),
                        decoration: textFieldDecoration("Email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val){
                          if(val.length < 6){
                            return "Password must be at least 6 characters long!";
                          }
                          return null;
                        },
                        controller: passwordTextController,
                        style: textFieldStyle(),
                        decoration: textFieldDecoration("Password"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                GestureDetector(
                  onTap: (){
                    signMeUp();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              const Color(0xff007EF4),
                              const Color(0xff2A75BC),
                            ]
                        ),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Text("Sign Up Now", style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),),
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text("Sign Up with Google", style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                  ),),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: textFieldStyle2(),),
                    GestureDetector(
                      onTap: (){
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Log In here", style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline,
                        ),),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

