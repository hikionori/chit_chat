import 'package:chit_chat/app/blocs/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageDesktop extends StatefulWidget {
  const HomePageDesktop({super.key});

  @override
  State<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends State<HomePageDesktop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Home Page Desktop'),
            ElevatedButton(
                onPressed: () {
                  // change theme
                  BlocProvider.of<ThemeCubit>(context).toggleTheme();
                },
                child: const Text('Change Theme')),
          ],
        ),
      ),
    );
  }
}
