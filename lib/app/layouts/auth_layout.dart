import 'dart:io';

import 'package:chit_chat/app/pages/auth/auth_page_desktop.dart';
import 'package:chit_chat/app/pages/auth/auth_page_mobile.dart';
import 'package:flutter/material.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (Platform.isAndroid || Platform.isIOS) {
        return const AuthPageMobile();
      } else {
        return const AuthPageDesktop();
      }
    });
  }
}
