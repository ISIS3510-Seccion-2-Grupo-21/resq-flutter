import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_event.dart';
part 'update_user_state.dart';

class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UserRepository userRepository;

  UpdateUserBloc({required this.userRepository}) : super(UpdateUserInitial());

  @override
  Stream<UpdateUserState> mapEventToState(UpdateUserEvent event) async* {
    if (event is UpdateUserData) {
      yield UpdateUserProcess();
      try {
        await userRepository.updateUserData(event.updatedUser);
        yield UpdateUserSuccess();
      } on Exception catch (e) {
        yield UpdateUserFailure(message: e.toString());
      }
    }
  }
}
