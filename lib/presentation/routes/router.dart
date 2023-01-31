import 'package:auto_route/auto_route.dart';
import 'package:domain_driven_tut/presentation/notes/notes_overview/notes_overview_page.dart';
import 'package:domain_driven_tut/presentation/splash/splash_page.dart';
import 'package:flutter/material.dart';
import '../sign_in/sign_in_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(
      page: SplashPage,
      initial: true,
    ),
    MaterialRoute(
      page: SignInPage,
    ),
    MaterialRoute(
      page: NotesOverViewPage,
    ),
  ],
  preferRelativeImports: true,
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {}
