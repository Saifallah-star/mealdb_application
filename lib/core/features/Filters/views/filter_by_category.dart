import 'package:flutter/material.dart';
import 'package:mealdb_application/root.dart';

class FilterByCategory extends StatelessWidget {
  const FilterByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Root(count: 2)),
            );
          },
        ),
      ),
      body: const Center(child: Text('Filter by Category Page')),
    );
  }
}
