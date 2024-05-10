import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(prefixIcon: Icon(Icons.abc)),
    );
  }
}
