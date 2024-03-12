import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const Text("Search your University"),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchUniversityList());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

class SearchUniversityList extends SearchDelegate {

  List<String> searchTerms = [
    "Universidad de los andes",
    "Universidad de la sabana",
    "Universidad nacional",
  ];

  void signIn(String university) {
    print("Sign In");
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var university in searchTerms) {
      if (university.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(university);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            signIn(result);
            close(context, result);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var university in searchTerms) {
      if (university.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(university);
      }
    }

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            query = result;
          },
        );
      },
    );
  }
}