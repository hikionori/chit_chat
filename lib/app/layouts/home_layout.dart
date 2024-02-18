import 'dart:io';

import 'package:chit_chat/app/pages/home/home_page_desktop.dart';
import 'package:chit_chat/app/pages/home/home_page_mobile.dart';
import 'package:flutter/material.dart';

class HomePageLayout extends StatelessWidget {
  const HomePageLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (Platform.isAndroid || Platform.isIOS) {
        return const HomePageMobile();
      } else {
        return const HomePageDesktop();
      }
    });
  }
}
