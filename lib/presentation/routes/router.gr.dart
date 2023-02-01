// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SplashPage(),
      );
    },
    SignInRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SignInPage(),
      );
    },
    NotesOverViewRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const NotesOverViewPage(),
      );
    },
    NoteFormRoute.name: (routeData) {
      final args = routeData.argsAs<NoteFormRouteArgs>(
          orElse: () => const NoteFormRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: NoteFormPage(
          key: args.key,
          editedNote: args.editedNote,
        ),
        fullscreenDialog: true,
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        RouteConfig(
          SignInRoute.name,
          path: '/sign-in-page',
        ),
        RouteConfig(
          NotesOverViewRoute.name,
          path: '/notes-over-view-page',
        ),
        RouteConfig(
          NoteFormRoute.name,
          path: '/note-form-page',
        ),
      ];
}

/// generated route for
/// [SplashPage]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [SignInPage]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/sign-in-page',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [NotesOverViewPage]
class NotesOverViewRoute extends PageRouteInfo<void> {
  const NotesOverViewRoute()
      : super(
          NotesOverViewRoute.name,
          path: '/notes-over-view-page',
        );

  static const String name = 'NotesOverViewRoute';
}

/// generated route for
/// [NoteFormPage]
class NoteFormRoute extends PageRouteInfo<NoteFormRouteArgs> {
  NoteFormRoute({
    Key? key,
    Note? editedNote,
  }) : super(
          NoteFormRoute.name,
          path: '/note-form-page',
          args: NoteFormRouteArgs(
            key: key,
            editedNote: editedNote,
          ),
        );

  static const String name = 'NoteFormRoute';
}

class NoteFormRouteArgs {
  const NoteFormRouteArgs({
    this.key,
    this.editedNote,
  });

  final Key? key;

  final Note? editedNote;

  @override
  String toString() {
    return 'NoteFormRouteArgs{key: $key, editedNote: $editedNote}';
  }
}
