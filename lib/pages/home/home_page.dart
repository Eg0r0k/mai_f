import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mai_f/widgets/corusel_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: CustomSearch());
                  },
                  icon: Icon(Icons.search)),
            ]),
        body: RefreshIndicator(
            onRefresh: () async {
              print('Refresh');
            },
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    MainCorusel(),
                  ],
                ),
              ),
            )));
  }
}

class CustomSearch extends SearchDelegate {
  List<String> data = ['Popular', 'Text', 'Test2'];
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        appBarTheme:
            AppBarTheme(color: Theme.of(context).colorScheme.background));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () async {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> mathQuery = [];

    for (var item in data) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        mathQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: mathQuery.length,
      itemBuilder: (context, index) {
        var result = mathQuery[index];
        return ListTile(
          onTap: () {
            query = result;
          },
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> mathQuery = [];
    for (var item in data) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        mathQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: mathQuery.length,
      itemBuilder: (context, index) {
        var result = mathQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
