import 'package:flutter/material.dart';

class PersonProfilePage extends StatelessWidget {
  const PersonProfilePage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kullanıcı Profili')),
      body: Center(child: Text('Kullanıcı ID: $id')),
    );
  }
}
