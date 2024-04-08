import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq/screens/auth/login_process_view.dart';
import 'package:resq/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

class LoginProcess extends StatelessWidget {
  final UserRepository userRepository;
  const LoginProcess(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(
				userRepository: userRepository
			),
      child: const LoginProcessView(),
    );
  }
}