import 'package:domain_driven_tut/application/core/bloc_provider.dart';
import 'package:domain_driven_tut/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UncompletedSwitch extends HookWidget {
  const UncompletedSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final toggleState = useState(false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkResponse(
        onTap: () {
          toggleState.value = !toggleState.value;
          context.bloc<NoteWatcherBloc>().add(toggleState.value
              ? const NoteWatcherEvent.watchUncompletedStarted()
              : const NoteWatcherEvent.watchAllStarted());
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: toggleState.value
              ? const Icon(
                  key: ValueKey('outline'), Icons.check_box_outline_blank)
              : const Icon(
                  key: ValueKey('indeterminate'),
                  Icons.indeterminate_check_box),
        ),
      ),
    );
  }
}
