import 'package:domain_driven_tut/application/core/bloc_provider.dart';
import 'package:domain_driven_tut/application/notes/note_actor/note_actor_bloc.dart';
import 'package:domain_driven_tut/domain/notes/note.dart';
import 'package:domain_driven_tut/domain/notes/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:kt_dart/kt.dart';

class NoteCardWidget extends StatelessWidget {
  final Note note;
  const NoteCardWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: note.color.getOrCrash(),
      child: InkWell(
        onTap: () {
          // TODO: Implement naviation
        },
        onLongPress: () {
          final noteActorBloc = context.bloc<NoteActorBloc>();
          _showDeletionDialog(context, noteActorBloc);
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.body.getOrCrash(),
                style: const TextStyle(fontSize: 18),
              ),
              if (note.todos.length > 0) ...[
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    ...note.todos
                        .getOrCrash()
                        .map((todo) => TodoDisplay(todo: todo))
                        .iter
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDeletionDialog(BuildContext context, NoteActorBloc noteActorBloc) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Selected note:'),
            content: Text(
              note.body.getOrCrash(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  noteActorBloc.add(NoteActorEvent.deleted(note));
                  Navigator.pop(context);
                },
                child: const Text('DELETE'),
              ),
            ],
          );
        });
  }
}

class TodoDisplay extends StatelessWidget {
  final TodoItem todo;
  const TodoDisplay({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (todo.done)
          Icon(
            Icons.check_box,
            color: Theme.of(context).colorScheme.secondary,
          )
        else
          Icon(
            Icons.check_box_outline_blank,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        Text(todo.name.getOrCrash()),
      ],
    );
  }
}
