import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:domain_driven_tut/application/core/bloc_provider.dart';
import 'package:domain_driven_tut/application/notes/note_form/note_form_bloc.dart';
import 'package:domain_driven_tut/injection.dart';
import 'package:domain_driven_tut/presentation/notes/note_form/widgets/body_field_widget.dart';
import 'package:domain_driven_tut/presentation/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/notes/note.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;

  const NoteFormPage({super.key, this.editedNote});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(NoteFormEvent.initialized(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (prev, curr) =>
            prev.saveFailureOrSuccessOption != curr.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () {},
            (either) {
              either.fold(
                (failure) {
                  FlushbarHelper.createError(
                      message: failure.map(
                    unexpected: (_) =>
                        'Unexpected error occurred, please contact support.',
                    unableToUpdate: (_) =>
                        'Couldn\'t update the note. Was it deleted from another device?',
                    insufficientPermission: (_) => 'Insufficient permissions ❌',
                  )).show(context);
                },
                (_) {
                  context.router.popUntil(
                    (route) => route.settings.name == NotesOverViewRoute.name,
                  );
                },
              );
            },
          );
        },
        buildWhen: (prev, current) => prev.isSaving != current.isSaving,
        builder: (context, state) {
          return Stack(
            children: [
              const NoteFormPageScaffold(),
              SaveInProgressOverlay(isSaving: state.isSaving),
            ],
          );
        },
      ),
    );
  }
}

class SaveInProgressOverlay extends StatelessWidget {
  final bool isSaving;

  const SaveInProgressOverlay({
    super.key,
    required this.isSaving,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        child: Visibility(
          visible: isSaving,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              Text(
                'Saving',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (prev, curr) => prev.isEditing != curr.isEditing,
          builder: (context, state) {
            return Text(state.isEditing ? 'Edit a note' : 'Create a note');
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.bloc<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (prev, curr) =>
            prev.showErrorMessages != curr.showErrorMessages,
        builder: (context, state) {
          return Form(
            autovalidateMode: state.showErrorMessages
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: SingleChildScrollView(
              child: Column(
                children: const [
                  BodyField(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
