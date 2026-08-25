import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSubmitted;

  const Search({
    super.key,
    required this.searchController,
    required this.onSubmitted,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Expanded(
        child: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Want a certain meal?......',
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
          ),
          onFieldSubmitted: (value) {
            onSubmitted(value.trim());
          },
        ),
      ),
    );
  }
}
