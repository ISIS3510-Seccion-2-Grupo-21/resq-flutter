import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:resq/screens/home_screen.dart';
import 'package:resq/screens/search_screen.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search',
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return const HomeScreen();
          } else {
            return const SearchScreen();
          }
        },
      )
    );
  }
}