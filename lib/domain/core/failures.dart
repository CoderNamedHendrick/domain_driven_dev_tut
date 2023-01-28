import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class ValueFailure<T> with _$ValueFailure<T> {
  const factory ValueFailure.invalidEamil({
    required final String failedValue,
  }) = InvalidEmail<T>;

  const factory ValueFailure.shortPassword({
    required final String failedValue,
  }) = ShortPassword<T>;
}
