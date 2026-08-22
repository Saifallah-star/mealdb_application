import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_category.dart';
import 'package:mealdb_application/core/features/home/data/Repository/home_repo.dart';
import 'package:mealdb_application/core/features/home/data/models/category_model.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List<CategoryModel> categories = [];
  Future<void> fetchCategories() async {
    try {
      final response = await HomeRepo().getAllCategories();
      setState(() {
        categories = response;
      });
    } on DioException catch (e) {
      ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(AllCategories) Failed to load data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => FilterByCategory()),
                );
              },
              title: Text(category.name ?? 'Unnamed Category'),
            ),
          );
        },
      ),
    );
  }
}
