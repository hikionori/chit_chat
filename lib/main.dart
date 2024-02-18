import 'dart:io';

import 'package:chit_chat/app/app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    // set up window
    await windowManager.waitUntilReadyToShow(null, () async {
      // set title
      await windowManager.setTitle('Chit Chat');
      // set app icon
      await windowManager.setIcon('assets/icon/mid_logo.png');

      await windowManager.show();

      // set fixed size 900x650
      await windowManager.setMinimumSize(const Size(900, 650));
      await windowManager.setSize(const Size(900, 650));
      await windowManager.setMaximumSize(const Size(900, 650));

      // disable resizing
      await windowManager.setResizable(false);
      await windowManager.setFullScreen(false);
      await windowManager.setMinimizable(true);
      await windowManager.setMaximizable(false);

      await windowManager.focus();
    });
  }

  runApp(const MyApp());
}
