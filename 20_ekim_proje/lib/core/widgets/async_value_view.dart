// =============================================================================
// async_value_view.dart - Asenkron veriyi (AsyncValue) ekrana çeviren ortak widget
// Riverpod'daki FutureProvider/AsyncNotifier'lar üç durumdan birinde olur:
//   loading (yükleniyor), data (veri geldi), error (hata).
// Her sayfada bu üç durumu tek tek yazmak yerine bu widget kullanılır:
//   yükleniyor -> iskelet (skeleton), hata -> tekrar dene butonu, veri -> data().
// Ayrıca veri boşsa (empty) özel bir "boş durum" ekranı gösterebilir.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'error_state.dart';
import 'skeleton_list.dart';

// Generic <T>: her veri tipiyle (List<Mentor>, Program ...) çalışabilir.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.empty,
    this.emptyBuilder,
    this.onRetry,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  // Verinin "boş" sayılıp sayılmayacağına karar veren fonksiyon (ör. (list) => list.isEmpty).
  final bool Function(T data)? empty;
  final Widget Function()? emptyBuilder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    // when: AsyncValue'nun durumuna göre ilgili fonksiyonu çağırır.
    return value.when(
      // Yenileme sırasında eski veri ekranda kalır; her yenilemede iskelet yanıp sönmez.
      skipLoadingOnReload: true,
      data: (item) {
        if (empty != null && empty!(item) && emptyBuilder != null) {
          return emptyBuilder!();
        }
        return data(item);
      },
      loading: () => loading != null ? loading!() : const SkeletonList(),
      error: (err, _) => ErrorState(
        message: err.toString(),
        onRetry: onRetry,
      ),
    );
  }
}
