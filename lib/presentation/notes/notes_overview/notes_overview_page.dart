import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain_driven_tut/application/auth/auth_bloc.dart';
import 'package:domain_driven_tut/application/core/bloc_provider.dart';
import 'package:domain_driven_tut/application/notes/note_actor/note_actor_bloc.dart';
import 'package:domain_driven_tut/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:domain_driven_tut/injection.dart';
import 'package:domain_driven_tut/presentation/notes/notes_overview/widgets/notes_overview_body.dart';
import 'package:domain_driven_tut/presentation/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:domain_driven_tut/presentation/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesOverViewPage extends StatelessWidget {
  const NotesOverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) => getIt<NoteWatcherBloc>()
            ..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                unAuthenticated: (_) =>
                    context.router.replaceNamed(const SignInRoute().path),
                orElse: () {},
              );
            },
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: (context, state) {
              state.maybeMap(
                deleteFailure: (state) {
                  FlushbarHelper.createError(
                    message: state.noteFailure.map(
                      unexpected: (_) =>
                          'Unexpected error occurred while deleting, please contact support',
                      unableToUpdate: (_) => 'Impossible error',
                      insufficientPermission: (_) =>
                          'Insufficient permissions ❌',
                    ),
                    duration: const Duration(seconds: 5),
                  ).show(context);
                },
                orElse: () {},
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Notes'),
            leading: IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                context.bloc<AuthBloc>().add(const AuthEvent.signedOut());
              },
            ),
            actions: const [UncompletedSwitch()],
          ),
          body: const NotesOverviewBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.router.pushNamed(NoteFormRoute(editedNote: null).path);
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
