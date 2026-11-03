// =============================================================================
// post_composer_page.dart - Yeni gönderi yazma sayfası
// Şimdilik yer tutucu (placeholder); form henüz yapılmadı.
// Repository'de createPost metodu hazır, form bağlandığında kullanılabilir.
// =============================================================================

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
