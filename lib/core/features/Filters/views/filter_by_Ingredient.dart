import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/components/filter_wide_card.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Repositories/filters_repo.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';
import 'package:mealdb_application/root.dart';

class FilterByIngredient extends StatefulWidget {
  const FilterByIngredient({super.key, required this.mealName});
  final String mealName;

  @override
  State<FilterByIngredient> createState() => _FilterByIngredientState();
}

class _FilterByIngredientState extends State<FilterByIngredient> {
  List<FilterModel> Ingredients = [];

  // the respoonse is not empty
  Future<void> FilterByIngredient(String name) async {
    try {
      final response = await FiltersRepo().FilterByIngredient(name);
      if (!mounted)
        return; // to avoid calling setState if the widget is not mounted
      setState(() {
        Ingredients = response;
      });
    } on DioException catch (e) {
      throw ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(FilterByIngredient) Failed to load data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    FilterByIngredient(widget.mealName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Root(count: 0)),
            );
          },
        ),
        title: Text(
          'Meals with ${widget.mealName}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: Ingredients.length,
        itemBuilder: (context, index) {
          final Ingredient = Ingredients[index];
          return FilterWideCard(
            model: Ingredient,
            In: widget.mealName,
            filterType: 'ingredient',
          );
        },
      ),
    );
  }
}
