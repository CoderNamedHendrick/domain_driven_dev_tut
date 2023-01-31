import 'package:auto_route/auto_route.dart';
import 'package:domain_driven_tut/presentation/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:domain_driven_tut/application/auth/auth_bloc.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          authenticated: (_) {
            context.router.replaceNamed(const NotesOverViewRoute().path);
          },
          unAuthenticated: (_) =>
              context.router.replaceNamed(const SignInRoute().path),
        );
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
