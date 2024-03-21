part of 'update_user_bloc.dart';

sealed class UpdateUserState extends Equatable {
  const UpdateUserState();
  
  @override
  List<Object> get props => [];
}

final class UpdateUserInitial extends UpdateUserState {}
