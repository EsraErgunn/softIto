import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'error_state.dart';
import 'skeleton_list.dart';

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
  final bool Function(T data)? empty;
  final Widget Function()? emptyBuilder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return value.when(
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
