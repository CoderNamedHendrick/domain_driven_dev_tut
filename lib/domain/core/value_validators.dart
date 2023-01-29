import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';
import 'failures.dart';

Either<ValueFailure<String>, String> validateMaxStringLength(
  String input,
  int maxLength,
) {
  if (input.length <= maxLength) {
    return Right(input);
  }

  return Left(
    ValueFailure.exceedingLength(failedValue: input, max: maxLength),
  );
}

Either<ValueFailure<String>, String> validateStringNotEmpty(String input) {
  if (input.isNotEmpty) {
    return Right(input);
  }

  return Left(ValueFailure.empty(failedValue: input));
}

Either<ValueFailure<String>, String> validateSingleLine(String input) {
  if (!input.contains('\\n')) {
    return Right(input);
  }

  return Left(ValueFailure.multiline(failedValue: input));
}

Either<ValueFailure<KtList<T>>, KtList<T>> validateMaxListLenght<T>(
  KtList<T> input,
  int maxLength,
) {
  if (input.size <= maxLength) {
    return Right(input);
  }

  return Left(ValueFailure.listTooLong(failedValue: input, max: maxLength));
}

Either<ValueFailure<String>, String> validateEmailAddress(String input) {
  const emailRegex =
      r'''^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$''';
  if (RegExp(emailRegex).hasMatch(input)) {
    return Right(input);
  }

  return Left(ValueFailure.invalidEamil(failedValue: input));
}

Either<ValueFailure<String>, String> validatePassword(String input) {
  if (input.length >= 6) {
    return Right(input);
  }

  return Left(ValueFailure.shortPassword(failedValue: input));
}
