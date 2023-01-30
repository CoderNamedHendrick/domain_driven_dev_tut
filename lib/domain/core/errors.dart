// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:domain_driven_tut/domain/core/failures.dart';

class NotAuthenticatedError extends Error {}

class UnExpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnExpectedValueError(this.valueFailure);

  @override
  String toString() {
    const explanation =
        'Encountered a ValueFailure at an unrecoverable point. Terminating.';
    return Error.safeToString('$explanation Failure was: $valueFailure');
  }
}
