import 'package:domain_driven_tut/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:domain_driven_tut/presentation/sign_in/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: BlocProvider(
        create: (context) => getIt<SignInFormBloc>(),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: SignInForm(),
        ),
      ),
    );
  }
}
