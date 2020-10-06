import 'package:flutter/material.dart';
import 'package:fast_chat/screens/welcome_screen.dart';
import 'package:fast_chat/screens/login_screen.dart';
import 'package:fast_chat/screens/registration_screen.dart';
import 'package:fast_chat/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _auth = FirebaseAuth.instance;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getCurrentUser();
  String a = getLandingPage() ? '/Chat' : '/';
  return runApp(
    new MaterialApp(
        routes: {
          '/': (context) => WelcomeScreen(),
          '/Chat': (context) => ChatScreen(),
          '/Login': (context) => LoginScreen(),
          '/Registration': (context) => RegistrationScreen(),
        },
        initialRoute: a,
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            body1: TextStyle(color: Colors.black54),
          ),
        )),
  );
}

bool getLandingPage() {
  print('my user is  :  $_myUser');
  if (_myUser != null) {
    return true;
  }

  return false;
}

FirebaseUser _myUser;
Future getCurrentUser() async {
  try {
    final user = await _auth.currentUser();
    if (user != null) {
      _myUser = user;
      print(_myUser.email);
    }
  } catch (e) {
    // TODO
    print(e);
  }
}
