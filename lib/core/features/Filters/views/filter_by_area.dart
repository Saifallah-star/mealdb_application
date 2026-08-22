import 'package:flutter/material.dart';
import 'package:mealdb_application/core/features/home/data/models/Area_model.dart';
import 'package:mealdb_application/root.dart';

class FilterByArea extends StatelessWidget {
  final AreaModel area;

  const FilterByArea({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Root(count: 1)),
            );
          },
        ),
      ),
      body: const Center(child: Text('Filter by Area Page')),
    );
  }
}
