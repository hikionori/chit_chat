import 'dart:io';

import 'package:chit_chat/app/app.dart';
import 'package:chit_chat/app/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// void send_form_data_http() async {
//   var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(
//           'https://t82zk15t-54321.euw.devtunnels.ms/functions/v1/upload'));
//   request.files.add(await http.MultipartFile.fromPath(
//       'file', '/home/hikionori/Documents/Projects/chit_chat/pubspec.yaml'));
//   for (var file in request.files) {
//     print(file.field);
//     print(file.filename);
//     print(file.length);

//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Supabase
  await Supabase.initialize(
    url: "https://t82zk15t-54321.euw.devtunnels.ms/",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0",
  );

  final chatService = ChatService();
  chatService.sendMessage("New message", null);

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    await windowManager.ensureInitialized();
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
