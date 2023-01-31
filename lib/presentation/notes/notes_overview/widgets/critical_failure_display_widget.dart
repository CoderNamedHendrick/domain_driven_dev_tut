import 'package:domain_driven_tut/domain/notes/note_failure.dart';
import 'package:flutter/material.dart';

class CriticalFailureDisplay extends StatelessWidget {
  final NoteFailure failure;
  const CriticalFailureDisplay({super.key, required this.failure});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '😱',
            style: TextStyle(fontSize: 100),
            textAlign: TextAlign.center,
          ),
          Text(
            failure.maybeMap(
                insufficientPermission: (_) => 'Insufficient permissions',
                orElse: () => 'Unexpected error. \nPlease, contact support.'),
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: () {
              debugPrint('Sending Email...');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.mail),
                SizedBox(width: 4),
                Text('I NEED HELP')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
