import 'package:domain_driven_tut/application/core/bloc_provider.dart';
import 'package:domain_driven_tut/application/notes/note_form/note_form_bloc.dart';
import 'package:domain_driven_tut/domain/notes/value_objects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BodyField extends HookWidget {
  const BodyField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    return BlocListener<NoteFormBloc, NoteFormState>(
      listenWhen: (prev, curr) => prev.isEditing != curr.isEditing,
      listener: (context, state) {
        textEditingController.text = state.note.body.getOrCrash();
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(
            labelText: 'Note',
            counterText: '',
          ),
          maxLength: NoteBody.maxLength,
          maxLines: null,
          minLines: 5,
          onChanged: (value) => context
              .bloc<NoteFormBloc>()
              .add(NoteFormEvent.bodyChanged(value)),
          validator: (_) => context
              .bloc<NoteFormBloc>()
              .state
              .note
              .body
              .value
              .fold(
                  (f) => f.maybeMap(
                      orElse: () => null,
                      empty: (_) => 'Cannot be empty',
                      exceedingLength: (f) => 'Exceeding length, max ${f.max}'),
                  (r) => null),
        ),
      ),
    );
  }
}
