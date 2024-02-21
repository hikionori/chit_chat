import 'dart:io';

import 'package:chit_chat/app/pages/chat/chat_page_desktop.dart';
import 'package:chit_chat/app/pages/chat/chat_page_mobile.dart';
import 'package:flutter/material.dart';

class ChatPageLayout extends StatelessWidget {
  const ChatPageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (Platform.isAndroid || Platform.isIOS) {
        return const ChatPageMobile();
      } else {
        return const ChatPageDesktop();
      }
    });
  }
}
