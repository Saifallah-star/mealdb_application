import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/category_model.dart';
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
  List<CategoryModel> categories = [];
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
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
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
                        Image.network(
                          category.imageUrl,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.restaurant_menu,
                              color: AppColors.SelectedColor,
                              size: 50,
                            );
                          },
                        ),
                        const SizedBox(height: 8.0),
                        // Name
                        Row(
                          children: [
                            Text(
                              'Name: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                category.name,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Area
                        Row(
                          children: [
                            Text(
                              'Area: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                category.Area! ?? 'N/A',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        // Country
                        Row(
                          children: [
                            Text(
                              'Country: ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                category.Country! ?? 'N/A',
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
