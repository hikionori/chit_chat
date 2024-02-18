import 'package:chit_chat/app/blocs/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({super.key});

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          children: [
            const Text('Home Page Desktop'),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<ThemeCubit>(context).toggleTheme();
              },
              child: const Text('Go to Auth Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Supabase.instance.client.auth.signOut();
                context.go('/auth');
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
