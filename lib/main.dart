import 'dart:io';

import 'package:chit_chat/app/app.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Supabase
  await Supabase.initialize(
    url: "http://127.0.0.1:54321",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0",
  );

  await windowManager.ensureInitialized();

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    // set up window
    await windowManager.waitUntilReadyToShow(null, () async {
      // set title
      await windowManager.setTitle('Chit Chat');
      // set app icon
      await windowManager.setIcon('assets/images/mid_logo.png');

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
