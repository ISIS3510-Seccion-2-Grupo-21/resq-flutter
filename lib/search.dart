import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:resq/search_view.dart';
import 'package:user_repository/user_repository.dart';


class Search extends StatelessWidget {
  final UserRepository userRepository;

  const Search(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
        ),
      child: const SearchView(),
    );
  }
}