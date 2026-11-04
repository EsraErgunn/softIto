import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firestore_yonetim_ekrani.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const SoftitoFirestoreUygulamasi());
}

class SoftitoFirestoreUygulamasi extends StatelessWidget {
  const SoftitoFirestoreUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cloud Firestore",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const FirestoreYonetimEkrani(),
    );
  }
}
