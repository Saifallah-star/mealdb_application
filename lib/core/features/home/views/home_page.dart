import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/home/components/meal_card.dart';
import 'package:mealdb_application/core/features/home/components/search_bar.dart';
import 'package:mealdb_application/core/features/home/data/meal_model.dart';
import 'package:mealdb_application/core/shared/custom_text.dart';

class HomePage extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  List<MealModel> meals = [
    MealModel(
      name: 'Meal 1',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 1',
      category: '',
    ),
    MealModel(
      name: 'Meal 2',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 2',
      category: '',
    ),
    MealModel(
      name: 'Meal 3',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 3',
      category: '',
    ),
    MealModel(
      name: 'Meal 4',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 4',
      category: '',
    ),
    MealModel(
      name: 'Meal 1',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 1',
      category: '',
    ),
    MealModel(
      name: 'Meal 2',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 2',
      category: '',
    ),
    MealModel(
      name: 'Meal 3',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 3',
      category: '',
    ),
    MealModel(
      name: 'Meal 4',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 4',
      category: '',
    ),
    MealModel(
      name: 'Meal 1',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 1',
      category: '',
    ),
    MealModel(
      name: 'Meal 2',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 2',
      category: '',
    ),
    MealModel(
      name: 'Meal 3',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 3',
      category: '',
    ),
    MealModel(
      name: 'Meal 4',
      mealImage:
          'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
      Country: 'Country 4',
      category: '',
    ),
  ];
  HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          backgroundColor: AppColors.primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          // expandedHeight: 190,
          collapsedHeight: 145,
          title: CustomText(
            text: 'mealdb',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 130),
              Search(searchController: searchController),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              children: List.generate(
                meals.length,
                (index) => MealCard(
                  mealName: meals[index].name,
                  mealImage: meals[index].mealImage,
                  country: meals[index].Country,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
