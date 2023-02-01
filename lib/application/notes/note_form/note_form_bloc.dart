import 'dart:ui';

import 'package:domain_driven_tut/domain/notes/i_note_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/notes/value_objects.dart';
import '../../../presentation/notes/note_form/misc/todo_item_presentation_classes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/kt.dart';

import '../../../domain/notes/note.dart';
import '../../../domain/notes/note_failure.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<NoteFormEvent>((event, emit) async {
      await event.map(
        initialized: (e) {
          emit(
            e.initialNoteOption.fold(
              () => state,
              (initialNote) => state.copyWith(
                note: initialNote,
                isEditing: true,
              ),
            ),
          );
        },
        bodyChanged: (e) {
          emit(
            state.copyWith(
              note: state.note.copyWith(body: NoteBody(e.bodyStr)),
              saveFailureOrSuccessOption: const None(),
            ),
          );
        },
        colorChanged: (e) {
          emit(
            state.copyWith(
              note: state.note.copyWith(color: NoteColor(e.color)),
              saveFailureOrSuccessOption: const None(),
            ),
          );
        },
        todosChanged: (e) {
          emit(
            state.copyWith(
              note: state.note.copyWith(
                todos: List3(
                  e.todos.map((primitive) => primitive.toDomain()),
                ),
              ),
              saveFailureOrSuccessOption: const None(),
            ),
          );
        },
        saved: (e) async {
          Either<NoteFailure, Unit>? failureOrSuccess;
          emit(
            state.copyWith(
              isSaving: true,
              saveFailureOrSuccessOption: const None(),
            ),
          );

          if (state.note.failureOption.isNone()) {
            failureOrSuccess = state.isEditing
                ? await _noteRepository.update(state.note)
                : await _noteRepository.create(state.note);
          }

          emit(state.copyWith(
            isSaving: false,
            showErrorMessages: true,
            saveFailureOrSuccessOption: optionOf(failureOrSuccess),
          ));
        },
      );
    });
  }
}
