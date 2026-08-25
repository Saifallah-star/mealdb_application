import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/components/filter_wide_card.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Repositories/filters_repo.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/root.dart';

class FilterByCategory extends StatefulWidget {
  const FilterByCategory({super.key, required this.name});
  final String name;

  @override
  State<FilterByCategory> createState() => _FilterByCategoryState();
}

class _FilterByCategoryState extends State<FilterByCategory> {
  List<FilterModel> categories = [];
  Future<bool> timeout = Future.delayed(const Duration(seconds: 2), () => true);

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchCategories() async {
    try {
      final response = await FiltersRepo().FilterByCategory(widget.name);
      setState(() {
        categories = response;
      });
    } catch (e) {
      throw ApiError(message: '(FilterByCategory) Failed to load data: $e');
    }
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
              MaterialPageRoute(builder: (context) => const Root(count: 2)),
            );
          },
        ),
        title: Text(
          'Meals with ${widget.name}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: categories.isEmpty
          ? FutureBuilder<bool>(
              future: timeout,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.SelectedColor,
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.error,
                        color: AppColors.SelectedColor,
                        size: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No meals found for this category.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return FilterWideCard(
                  model: category,
                  In: widget.name,
                  filterType: 'category',
                );
              },
            ),
    );
  }
}
