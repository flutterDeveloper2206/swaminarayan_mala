import 'dart:convert';

import 'package:flutter/services.dart';

import '../constants/asset_constants.dart';

class NamavaliLabel {
  const NamavaliLabel({
    required this.index,
    required this.en,
    required this.hi,
    required this.gu,
  });

  final int index;
  final String en;
  final String hi;
  final String gu;

  String forLanguage(String languageCode) {
    switch (languageCode) {
      case 'hi':
        return hi.isNotEmpty ? hi : en;
      case 'gu':
        return gu.isNotEmpty ? gu : en;
      default:
        return en;
    }
  }

  factory NamavaliLabel.fromMap(Map<String, dynamic> map) {
    return NamavaliLabel(
      index: map['index'] as int? ?? 0,
      en: map['en'] as String? ?? '',
      hi: map['hi'] as String? ?? '',
      gu: map['gu'] as String? ?? '',
    );
  }
}

/// Loads original 108 remembrance labels for Sahajanand Namavali Path.
class NamavaliService {
  NamavaliService._();
  static final NamavaliService instance = NamavaliService._();

  List<NamavaliLabel> _labels = const [];
  bool _loaded = false;

  bool get isLoaded => _loaded;
  List<NamavaliLabel> get labels => _labels;

  Future<void> load() async {
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString(AssetConstants.namavaliLabelsJson);
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _labels = decoded
            .whereType<Map>()
            .map((e) => NamavaliLabel.fromMap(Map<String, dynamic>.from(e)))
            .toList()
          ..sort((a, b) => a.index.compareTo(b.index));
      }
      _loaded = true;
    } catch (_) {
      _labels = const [];
      _loaded = true;
    }
  }

  /// Bead position is 0–107 (next bead). Display uses 1–108.
  NamavaliLabel? labelForBead(int beadPosition) {
    if (_labels.isEmpty) return null;
    final displayIndex = beadPosition <= 0 ? 1 : (beadPosition % 108) + 1;
    try {
      return _labels.firstWhere((l) => l.index == displayIndex);
    } catch (_) {
      final i = (displayIndex - 1).clamp(0, _labels.length - 1);
      return _labels[i];
    }
  }

  static bool isNamavaliMantra(String? mantraId) =>
      mantraId == 'mantra_namavali_path';
}
