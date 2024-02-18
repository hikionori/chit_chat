import 'package:chit_chat/app/layouts/auth_layout.dart';
import 'package:chit_chat/app/layouts/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          const MaterialPage(child: HomePageLayout()),
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
