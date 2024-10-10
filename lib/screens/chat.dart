import 'package:chatapp/widgets/chatmessage.dart';
import 'package:chatapp/widgets/newmssg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  void pushnotification() async {
    final fcm = FirebaseMessaging.instance;
    //final notificatinsetting =
    await fcm.requestPermission();
    // notificatinsetting.announcement
    //final token = await fcm.getToken();
    //print(token);
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    pushnotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CHAT APP'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
        ),
        body: const Column(
          children: [Expanded(child: Chatmessage()), Newmssg()],
        ));
  }
}
