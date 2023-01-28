// ignore_for_file: unused_result

import 'package:dartz/dartz.dart';
import 'package:domain_driven_tut/domain/auth/i_auth_facade.dart';
import 'package:domain_driven_tut/domain/auth/value_objects.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/auth/auth_failure.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<SignInFormEvent>((event, emit) {
      event.map(
        emailChanged: (e) {
          emit(state.copyWith(
            emailAddress: EmailAddress(e.emailStr),
            authFailureOrSuccessOption: const None(),
          ));
        },
        passwordChanged: (e) {
          emit(state.copyWith(
            password: Password(e.passwordStr),
            authFailureOrSuccessOption: const None(),
          ));
        },
        registerWithEmailAndPasswordPressed: (e) {
          _performActionOnAuthFacadeWithEmailAndPassword(
            _authFacade.registerWithEmailAndPassword,
            emit,
          );
        },
        signInWithEmailAndPasswordPressed: (e) {
          _performActionOnAuthFacadeWithEmailAndPassword(
            _authFacade.signInWithEmailAndPassword,
            emit,
          );
        },
        signInWithGooglePressed: (e) async {
          emit(state.copyWith(
            isSubmitting: true,
            authFailureOrSuccessOption: const None(),
          ));

          final failureOrSuccess = await _authFacade.signInWithGoogle();

          emit(state.copyWith(
            isSubmitting: false,
            authFailureOrSuccessOption: Some(failureOrSuccess),
          ));
        },
      );
    });
  }

  void _performActionOnAuthFacadeWithEmailAndPassword(
    Future<Either<AuthFailure, Unit>> Function(
            {required EmailAddress emailAddress, required Password password})
        forwardedCall,
    Emitter<SignInFormState> emit,
  ) async {
    Either<AuthFailure, Unit>? failureOrSuccess;
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: const None(),
      ));

      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }

    emit(state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
