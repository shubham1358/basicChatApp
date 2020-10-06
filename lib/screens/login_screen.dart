import 'package:firebase_auth/firebase_auth.dart';
import 'package:fast_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;
  bool spinner = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextFields(
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                hintText: 'Enter your email',
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFields(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                hintText: 'Enter your password.',
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButton(
                tag: 'login',
                onPressed: () async {
                  setState(() {
                    spinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null)
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ChatScreen()),
                          (route) => false);
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    spinner = false;
                  });

                  //Implement login functionality.
                },
                text: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
