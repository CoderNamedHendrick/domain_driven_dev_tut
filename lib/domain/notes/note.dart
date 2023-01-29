import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import '../core/failures.dart';
import '../core/value_objects.dart';
import 'todo_item.dart';
import 'value_objects.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();

  const factory Note({
    required UniqueId id,
    required NoteBody body,
    required NoteColor color,
    required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(''),
        color: NoteColor(NoteColor.predefinedColors.first),
        todos: List3(emptyList()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    return body.failureOrUnit
        .andThen(todos.failureOrUnit)
        .andThen(todos
                .getOrCrash()
                .map((todoItem) => todoItem.failureOption)
                .filter((p0) => p0.isSome())
                .getOrElse(0, (_) => const None())
                .fold(() => const Right(unit), (f) => Left(f))
            as Either<ValueFailure<dynamic>, Unit>)
        .fold((f) => Some(f), (_) => const None());
  }
}
