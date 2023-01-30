import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:domain_driven_tut/domain/notes/i_note_repository.dart';
import 'package:domain_driven_tut/domain/notes/note.dart';
import 'package:domain_driven_tut/domain/notes/note_failure.dart';
import 'package:domain_driven_tut/infrastructure/notes/note_dtos.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';
import '../core/firestore_helpers.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final FirebaseFirestore _firestore;

  NoteRepository(this._firestore);

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => right<NoteFailure, KtList<Note>>(
            snapshot.docs
                .map((doc) => NoteDto.fromFirestore(doc).toDomain())
                .toImmutableList(),
          ),
        )
        .onErrorReturnWith((err, stackTrace) {
      if (err is PlatformException &&
          err.message!.contains('permission-denied')) {
        return const Left(NoteFailure.insufficientPermission());
      } else {
        return const Left(NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    final userDoc = await _firestore.userDocument();
    yield* userDoc.noteCollection
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => NoteDto.fromFirestore(doc).toDomain()),
        )
        .map(
          (notes) => right<NoteFailure, KtList<Note>>(notes
              .where((note) =>
                  note.todos.getOrCrash().any((todoItem) => !todoItem.done))
              .toImmutableList()),
        )
        .onErrorReturnWith((err, stackTrace) {
      if (err is PlatformException &&
          err.message!.contains('permission-denied')) {
        return const Left(NoteFailure.insufficientPermission());
      } else {
        return const Left(NoteFailure.unexpected());
      }
    });
  }

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);

      await userDoc.noteCollection.doc(noteDto.id!).set(noteDto.toJson());

      return const Right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('permission-denied')) {
        return const Left(NoteFailure.insufficientPermission());
      }

      return const Left(NoteFailure.unexpected());
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteId = note.id.getOrCrash();

      await userDoc.noteCollection.doc(noteId).delete();

      return const Right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('permission-denied')) {
        return const Left(NoteFailure.insufficientPermission());
      }

      if (e.message!.contains('not-found')) {
        return const Left(NoteFailure.unableToUpdate());
      }

      return const Left(NoteFailure.unexpected());
    }
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) async {
    try {
      final userDoc = await _firestore.userDocument();
      final noteDto = NoteDto.fromDomain(note);

      await userDoc.noteCollection.doc(noteDto.id!).update(noteDto.toJson());

      return const Right(unit);
    } on PlatformException catch (e) {
      if (e.message!.contains('permission-denied')) {
        return const Left(NoteFailure.insufficientPermission());
      }

      if (e.message!.contains('not-found')) {
        return const Left(NoteFailure.unableToUpdate());
      }

      return const Left(NoteFailure.unexpected());
    }
  }
}
