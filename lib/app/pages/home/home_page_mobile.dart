import 'package:chit_chat/app/blocs/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({super.key});

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text('Home Page Mobile'),
              ElevatedButton(
                onPressed: () {
                  // change theme
                  BlocProvider.of<ThemeCubit>(context).toggleTheme();
                },
                child: const Text('Change Theme'),
              ),
              ElevatedButton(
                onPressed: () {
                  // sign out
                  Supabase.instance.client.auth.signOut();
                  context.go('/auth');
                },
                child: const Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
