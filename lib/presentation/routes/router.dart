import 'package:auto_route/auto_route.dart';
import 'package:domain_driven_tut/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import '../sign_in/sign_in_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(
      page: SplashPage,
      initial: true,
    ),
    AutoRoute(
      path: '/sign-in',
      page: SignInPage,
    ),
  ],
  preferRelativeImports: true,
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {}
