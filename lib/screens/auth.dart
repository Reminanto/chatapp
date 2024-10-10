import 'dart:io';

import 'package:chatapp/widgets/imagepicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  final _formkey = GlobalKey<FormState>();
  var islogin = true;
  var enteredemail = '';
  var enteredpass = '';
  var enteredusername = '';
  var isauthticating = false;
  File? _selectedimage;
  void _submit() async {
    final isvalidate = _formkey.currentState!.validate();
    if (!isvalidate || !islogin && _selectedimage == null) {
      return;
      //err msg
    }

    _formkey.currentState!.save();
    try {
      setState(() {
        isauthticating = true;
      });
      if (islogin) {
        // login
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: enteredemail, password: enteredpass);
        print(userCredential);
      } else {
        // sign up
        final userCredential = await _firebase.createUserWithEmailAndPassword(
            email: enteredemail, password: enteredpass);
        // print(userCredential);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('userimage')
            .child('$userCredential.user!.uid}.jpg');

        await storageRef.putFile(_selectedimage!);
        final imageurl = await storageRef.getDownloadURL();
       // print(imageurl);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': enteredusername,
          'emailadddress': enteredemail,
          'image_url': imageurl
        });
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // handle email already in use error
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message ?? 'Authentication failed'),
      ));
      setState(() {
        isauthticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, right: 20, left: 20),
                width: 200,
                child: Image.asset('assets/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!islogin)
                            Imagepicker(
                              onPICKIMAGE: (pickedimage) {
                                _selectedimage = pickedimage;
                              },
                            ),
                            if(! islogin)
                          TextFormField(
                            enableSuggestions: false,
                            decoration: const InputDecoration(
                              label: Text('User Name'),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length <= 4) {
                                return 'Enter Valid Username';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              enteredusername = value!;
                            },
                          ),
                          TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Email Address'),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                enteredemail = value!;
                              }),
                          TextFormField(
                              decoration: const InputDecoration(
                                label: Text('Password'),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Please enter a valid password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                enteredpass = value!;
                              }),
                          const SizedBox(
                            height: 16,
                          ),
                          if (!isauthticating)
                            ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text(islogin ? 'LOGIN' : 'SIGNUP')),
                          if (isauthticating) const CircularProgressIndicator(),
                          if (!isauthticating)
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    islogin = !islogin;
                                  });
                                },
                                child: Text(islogin
                                    ? 'Create an Account'
                                    : 'Already have an account'))
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
