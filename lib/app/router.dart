import 'package:chit_chat/app/layouts/auth_layout.dart';
import 'package:chit_chat/app/layouts/chat_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

final router = GoRouter(
  // if user is not authenticated, redirect to auth page
  redirect: (context, state) async {
    if (supabase.auth.currentUser == null) {
      return '/auth';
    } else {
      return '/';
    }
  },
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          const MaterialPage(child: ChatPageLayout()),
      routes: [
        GoRoute(
          path: 'auth',
          pageBuilder: (context, state) =>
              const MaterialPage(child: AuthPageLayout()),
        ),
      ],
    ),
  ],
);
