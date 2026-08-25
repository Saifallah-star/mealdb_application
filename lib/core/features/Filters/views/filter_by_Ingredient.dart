import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/Ingredient_model.dart';
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
  List<IngredientModel> Ingredients = [];

  // the respoonse is not empty
  Future<void> FilterByIngredient(String name) async {
    try {
      final response = await FiltersRepo().FilterByIngredient(name);

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
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
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
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: ListView.builder(
        itemCount: Ingredients.length,
        itemBuilder: (context, index) {
          final Ingredient = Ingredients[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: Column(
                children: [
                  Text('Name: ${Ingredient.name}'),
                  Text('Area: ${Ingredient.Area}'),
                  Text('Country: ${Ingredient.sCountry}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
