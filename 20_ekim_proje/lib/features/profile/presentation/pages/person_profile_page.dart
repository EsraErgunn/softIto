// =============================================================================
// person_profile_page.dart - Başka bir kullanıcının profil sayfası
// Şimdilik yer tutucu: sadece URL'den gelen kullanıcı id'sini gösterir.
// =============================================================================

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
