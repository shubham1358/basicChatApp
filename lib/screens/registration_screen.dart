import 'package:firebase_auth/firebase_auth.dart';
import 'package:fast_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                  //Do something with the user input.
                  email = value;
                },
                hintText: 'Enter your email',
              ),
              SizedBox(
                height: 8.0,
              ),
              TextFields(
                obscureText: true,
                onChanged: (value) {
                  //Do something with the user input.
                  password = value;
                },
                hintText: 'Enter your password',
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundButton(
                tag: 'reg',
                onPressed: () async {
                  setState(() {
                    spinner = true;
                  });
                  //Implement registration functionality.
                  print('$email nd pswd $password');
                  try {
                    final user = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.pushReplacementNamed(context, '/Chat');
                    }
                  } catch (e) {
                    print('this exception:$e Exceptionend');
                  }
                  setState(() {
                    spinner = false;
                  });
                },
                text: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
