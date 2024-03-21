part of 'update_user_bloc.dart';

sealed class UpdateUserEvent extends Equatable {
  const UpdateUserEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserData extends UpdateUserEvent {
  final MyUser updatedUser;

  const UpdateUserData(this.updatedUser);
}
