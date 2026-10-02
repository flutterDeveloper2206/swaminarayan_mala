import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/routes.dart';
import 'core/navigation.dart';
import 'core/providers/app_state.dart';
import 'core/services/audio_service.dart';
import 'core/services/reminder_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final appState = AppState();
  await appState.init();
  await AudioService.instance.init();
  await ReminderService.instance.init(
    onTap: (payload) {
      final nav = appNavigatorKey.currentState;
      if (nav == null) return;
      String? mantraId;
      if (payload != null && payload.startsWith('jap|')) {
        final parts = payload.split('|');
        if (parts.length >= 2) mantraId = parts[1];
      }
      nav.pushNamed(AppRoutes.jap, arguments: mantraId);
    },
  );

  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const SwamiNaamApp(),
    ),
  );
}
