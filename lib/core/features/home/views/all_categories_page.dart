import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_category.dart';
import 'package:mealdb_application/core/features/home/data/Repository/home_repo.dart';
import 'package:mealdb_application/core/features/home/data/models/all_categories_model.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';
import 'package:shimmer/shimmer.dart';

class AllCategories extends StatefulWidget {
  const AllCategories({super.key});

  @override
  State<AllCategories> createState() => _AllCategoriesState();
}

class _AllCategoriesState extends State<AllCategories> {
  List<AllCategoriesModel> categories = [];
  bool isLoading = true;
  Future<void> fetchCategories() async {
    try {
      final response = await HomeRepo().getAllCategories();
      setState(() {
        categories = response;
        isLoading = false;
      });
    } on DioException catch (e) {
      ApiException.handleException(e);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
    return isLoading
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: 8,
              itemBuilder: (context, index) {
                return Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              },
            ),
          )
        : ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 15.0,
                ),
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
                  tileColor: Colors.grey.withOpacity(0.1),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>
                            FilterByCategory(name: category.name!),
                      ),
                    );
                  },
                  title: Row(
                    children: [
                      const Icon(
                        Icons.restaurant_menu,
                        color: AppColors.SelectedColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Category: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.SelectedColor,
                        ),
                      ),
                      SizedBox(width: 30),
                      Text(
                        category.name ?? 'Unnamed Category',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: AppColors.SelectedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
