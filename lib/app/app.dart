import 'package:chit_chat/app/blocs/cubit/theme_cubit.dart';
import 'package:chit_chat/app/router.dart';
import 'package:chit_chat/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Chit Chat',
            theme: context.read<ThemeCubit>().state == ThemeMode.light
                ? materialTheme.light()
                : materialTheme.dark(),
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
