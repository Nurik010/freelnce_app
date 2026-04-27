import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_bloc.dart';
import 'package:freelance_app/bloc/auth_bloc/auth_state.dart';
import 'package:freelance_app/screens/register_screen.dart';
import 'package:freelance_app/screens/main_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainScreen();
        }
        if (state is AuthUnauthenticated) {
          return const RegisterScreen();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}