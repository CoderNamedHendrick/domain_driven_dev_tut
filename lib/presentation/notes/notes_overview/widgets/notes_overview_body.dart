import 'package:domain_driven_tut/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:domain_driven_tut/presentation/notes/notes_overview/widgets/critical_failure_display_widget.dart';
import 'package:domain_driven_tut/presentation/notes/notes_overview/widgets/error_note_card_widget.dart';
import 'package:domain_driven_tut/presentation/notes/notes_overview/widgets/note_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesOverviewBody extends StatelessWidget {
  const NotesOverviewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteWatcherBloc, NoteWatcherState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => Container(),
          loadInProgres: (_) =>
              const Center(child: CircularProgressIndicator()),
          loadSuccess: (state) {
            return ListView.builder(
              itemCount: state.notes.size,
              itemBuilder: (context, index) {
                final note = state.notes.get(index);

                if (note.failureOption.isSome()) {
                  return ErrorNoteCard(note: note);
                }

                return NoteCardWidget(note: note);
              },
            );
          },
          loadFailure: (state) {
            return CriticalFailureDisplay(failure: state.noteFailure);
          },
        );
      },
    );
  }
}
