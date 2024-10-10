import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Newmssg extends StatefulWidget {
  const Newmssg({super.key});

  @override
  State<Newmssg> createState() => _NewmssgState();
}

class _NewmssgState extends State<Newmssg> {
  final _mssgcontroller = TextEditingController();
  @override
  void dispose() {
    _mssgcontroller.dispose();
    super.dispose();
  }

  void _submittedmsg() async {
    final enteredmsg = _mssgcontroller.text;
    if (enteredmsg.trim().isEmpty) {
      return;
    }
      FocusScope.of(context).unfocus();
       _mssgcontroller.clear();
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredmsg,
      'time': Timestamp.now(),
      'userid': user.uid,
      'username': userData.data()!['username'],
      'userimage': userData.data()!['image_url'],
    });
    //send to firebase
   
  
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _mssgcontroller,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: const InputDecoration(labelText: 'Send Messages...'),
          )),
          IconButton(
            onPressed: _submittedmsg,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
