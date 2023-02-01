import 'package:auto_route/auto_route.dart';
import '../../domain/notes/note.dart';
import '../notes/note_form/note_form_page.dart';
import '../notes/notes_overview/notes_overview_page.dart';
import '../splash/splash_page.dart';
import 'package:flutter/material.dart';
import '../sign_in/sign_in_page.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage),
    MaterialRoute(page: NotesOverViewPage),
    MaterialRoute(page: NoteFormPage, fullscreenDialog: true)
  ],
  preferRelativeImports: true,
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends _$AppRouter {}
