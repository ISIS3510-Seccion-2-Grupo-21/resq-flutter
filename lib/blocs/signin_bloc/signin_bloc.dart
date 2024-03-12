import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final UserRepository _userRepository;
  
  SigninBloc({
    required UserRepository userRepository,
  }) : _userRepository = userRepository, 
    super(SigninInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
        await _userRepository.signIn();
        emit(SignInSuccess());
      } catch(e) {
        emit(SignInFailure());
      }
    });
  }
}
