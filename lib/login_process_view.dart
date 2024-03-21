import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:resq/screens/auth/welcome_screen.dart';
import 'blocs/sign_in_bloc/sign_in_bloc.dart';
import 'screens/home/home_screen.dart';

class LoginProcessView extends StatelessWidget {
  const LoginProcessView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
			title: 'Firebase Auth',
			theme: ThemeData(
				colorScheme: const ColorScheme.light(
          background: Colors.white,
          onBackground: Colors.black,
          primary: Color.fromRGBO(85, 210, 128, 1),
          onPrimary: Colors.black,
          secondary: Color.fromRGBO(28, 28, 28, 1),
          onSecondary: Colors.white,
					tertiary: Color.fromRGBO(80, 225, 130, 1),
          error: Colors.red,
					outline: Color(0xFF424242)
        ),
			),
			home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
				builder: (context, state) {
					if(state.status == AuthenticationStatus.authenticated) {
						return BlocProvider(
							create: (context) => SignInBloc(
								userRepository: context.read<AuthenticationBloc>().userRepository
							),
							child: const HomeScreen(),
						);
					} else {
						return const WelcomeScreen();
					}
				}
			)
		);
  }
}