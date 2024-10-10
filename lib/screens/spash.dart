import 'package:flutter/material.dart';

class Spash extends StatelessWidget {
  const Spash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHAT APP'),
      ),
      body: const Center(
        child:  Text('Loding....'),
      ),
    );
  }
}
