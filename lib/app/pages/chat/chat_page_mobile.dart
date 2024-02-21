import 'package:chit_chat/app/blocs/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatPageMobile extends StatefulWidget {
  const ChatPageMobile({super.key});

  @override
  State<ChatPageMobile> createState() => _ChatPageMobileState();
}

class _ChatPageMobileState extends State<ChatPageMobile> {
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
