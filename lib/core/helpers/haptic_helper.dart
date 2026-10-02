import 'package:flutter/services.dart';

class HapticHelper {
  HapticHelper._();

  static Future<void> light({required bool enabled}) async {
    if (!enabled) return;
    await HapticFeedback.lightImpact();
  }

  static Future<void> medium({required bool enabled}) async {
    if (!enabled) return;
    await HapticFeedback.mediumImpact();
  }

  static Future<void> heavy({required bool enabled}) async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
  }

  static Future<void> selection({required bool enabled}) async {
    if (!enabled) return;
    await HapticFeedback.selectionClick();
  }
}
