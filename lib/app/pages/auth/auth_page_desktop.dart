import 'package:chit_chat/app/widgets/desktop_input_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPageDesktop extends StatefulWidget {
  const AuthPageDesktop({super.key});

  @override
  State<AuthPageDesktop> createState() => _AuthPageDesktopState();
}

class _AuthPageDesktopState extends State<AuthPageDesktop> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/big_logo.png', height: 243, width: 243),
            Text("ChitChat", style: Theme.of(context).textTheme.displayLarge),
            // text field for email
            DesktopInputField(
                controller: _emailController,
                hintText: 'Email',
                inputType: TextInputType.emailAddress),
            const SizedBox(height: 23),
            // text field for password
            DesktopInputField(
                controller: _passwordController,
                hintText: 'Password',
                inputType: TextInputType.visiblePassword),
            const SizedBox(height: 23),
            // login button
            GestureDetector(
              onTap: () async {
                // if user dont have an account, create one
                handleLogin(context);
              },
              child: Container(
                width: 216,
                height: 60,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontFamily: 'FixelDisplay',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void handleLogin(BuildContext context) async {
    try {
      final response = await supabase.auth.signInWithPassword(
          password: _passwordController.text, email: _emailController.text);

      if (response.user != null) {
        GoRouter.of(context).go('/');
      }
    } catch (e) {
      if (e is AuthException) {
        // register user if user not found
        final response = await supabase.auth.signUp(
            email: _emailController.text, password: _passwordController.text);

        if (response.user != null) {
          GoRouter.of(context).go('/');
        }
      }
    }
  }
}
