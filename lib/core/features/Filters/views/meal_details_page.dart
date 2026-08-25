import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_Ingredient.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_area.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_category.dart';

class MealDP extends StatelessWidget {
  final FilterModel model;
  final String from;
  final String filterType;
  const MealDP({
    super.key,
    required this.model,
    required this.from,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.SelectedColor),
          onPressed: () {
            NavigateBack(context);
          },
        ),
        title: const Text('Meal Details'),
      ),
      body: Center(child: Text('Meal ID: ${model.id}')),
    );
  }

  void NavigateBack(BuildContext context) {
    if (filterType == 'category') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FilterByCategory(name: from)),
      );
    } else if (filterType == 'area') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => FilterByArea(area: from)),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FilterByIngredient(mealName: from),
        ),
      );
    }
  }
}
