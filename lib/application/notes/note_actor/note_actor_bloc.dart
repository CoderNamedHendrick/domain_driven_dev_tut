import 'package:dartz/dartz.dart';
import 'package:domain_driven_tut/domain/notes/i_note_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:domain_driven_tut/domain/notes/note.dart';
import 'package:domain_driven_tut/domain/notes/note_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'note_actor_event.dart';
part 'note_actor_state.dart';
part 'note_actor_bloc.freezed.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const NoteActorState.initial()) {
    on<NoteActorEvent>((event, emit) async {
      emit(const NoteActorState.actionInProgress());
      final possibleFailure = await _noteRepository.delete(event.note);

      emit(possibleFailure.fold(
        (f) => NoteActorState.deleteFailure(f),
        (_) => const NoteActorState.deleteSuccess(),
      ));
    });
  }
}
