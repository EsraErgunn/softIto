import 'package:flutter/material.dart';

class PostComposerPage extends StatelessWidget {
  const PostComposerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Gönderi Paylaş')),
      body: const Center(child: Text('Gönderi Yazma Alanı')),
    );
  }
}
