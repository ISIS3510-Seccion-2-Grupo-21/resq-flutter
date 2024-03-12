part of 'signin_bloc.dart';

sealed class SigninEvent extends Equatable {
  const SigninEvent();

  @override
  List<Object> get props => [];
}

class SignInRequired extends SigninEvent {
  final MyUser user;

  const SignInRequired(this.user);
}

class SignOutRequired extends SigninEvent {
  const SignOutRequired();
}

