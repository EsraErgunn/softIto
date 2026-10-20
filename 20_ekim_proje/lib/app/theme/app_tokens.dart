import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const xxs = 2.0;
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
  static const screenPadding = EdgeInsets.symmetric(horizontal: md);
}

abstract final class AppRadius {
  static const sm = 8.0;     // chip, küçük buton, input
  static const md = 16.0;    // kart
  static const lg = 24.0;    // bottom sheet, büyük panel
  static const full = 999.0; // rozet, avatar
}

abstract final class AppDurations {
  static const fast = Duration(milliseconds: 150);    // basma, toggle
  static const normal = Duration(milliseconds: 250);  // genel geçişler
  static const slow = Duration(milliseconds: 400);    // sayfa içi büyük değişim
  static const stagger = Duration(milliseconds: 50);  // liste öğeleri arası gecikme
}
