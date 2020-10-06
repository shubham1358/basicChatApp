import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fast_chat/constants.dart';

FirebaseUser _myUser;
final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = Firestore.instance;
  final textFController = TextEditingController();
  String message;
  void getCurrentUser() async {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.pop(context);
                } catch (e) {
                  // TODO
                  print(e);
                }
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StremBubble(firestore: _firestore),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textFController,
                      onChanged: (value) {
                        message = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      try {
                        textFController.clear();
                        final a = await _firestore.collection('messages').add({
                          'message': message,
                          'email': _myUser.email,
                          'time': FieldValue.serverTimestamp()
                        });

//                        print(a); // what is a
//                        await for (var snapshot
//                            in _firestore.collection('messages').snapshots())
//                          for (var message in snapshot.documents)
//                            print(message.data);
                      } catch (e) {
                        // TODO
                        print('Exceptio is : $e');
                      }
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StremBubble extends StatelessWidget {
  const StremBubble({
    Key key,
    @required Firestore firestore,
  })  : _firestore = firestore,
        super(key: key);

  final Firestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('messages')
            .orderBy(
              'time',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Bubble> messagesList = [];
          final allMessages = snapshot.data.documents;
          for (var allMessage in allMessages)
            messagesList.add(Bubble(
              message: allMessage.data['message'],
              email: allMessage.data['email'],
              thisIsMyEmail: allMessage.data['email'] == _myUser.email,
            ));
          return Expanded(
            child: ListView(
              reverse: true,
              children: messagesList,
            ),
          );
        });
  }
}

class Bubble extends StatelessWidget {
  final message;
  final email;
  final thisIsMyEmail;
  Bubble({this.message, this.email, this.thisIsMyEmail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            thisIsMyEmail ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            color: thisIsMyEmail ? Color(0xFF638184) : Colors.white,
            borderRadius: BorderRadius.only(
                topRight:
                    thisIsMyEmail ? Radius.circular(0) : Radius.circular(30),
                topLeft:
                    thisIsMyEmail ? Radius.circular(30) : Radius.circular(0),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            elevation: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                message,
                style: TextStyle(
                    color: thisIsMyEmail ? Colors.white : Colors.grey,
                    fontSize: 20),
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            email,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
