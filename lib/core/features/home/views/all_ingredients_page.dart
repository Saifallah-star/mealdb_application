import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/home/components/listingBarComponents/listing_bar.dart';
import 'package:mealdb_application/core/features/home/components/meal_card.dart';
import 'package:mealdb_application/core/features/home/components/search_bar.dart';
import 'package:mealdb_application/core/features/home/data/models/Ingredient_model.dart';
import 'package:mealdb_application/core/features/home/data/Repository/home_repo.dart';
import 'package:mealdb_application/core/shared/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllIngredientsPage extends StatefulWidget {
  AllIngredientsPage({super.key});

  @override
  State<AllIngredientsPage> createState() => _AllIngredientsPageState();
}

class _AllIngredientsPageState extends State<AllIngredientsPage> {
  final TextEditingController searchController = TextEditingController();

  List<IngredientModel> Ingredients = [];

  Future<void> fetchIngredients() async {
    try {
      final homeRepo = HomeRepo();
      final ingredients = await homeRepo.getIngredients();
      setState(() {
        Ingredients = ingredients;
      });
    } catch (e) {
      // Handle error
      print('Error fetching ingredients: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: Ingredients.isEmpty,
      child: CustomScrollView(
        slivers: [
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
                  Ingredients.length,
                  (index) => MealCard(mealName: Ingredients[index].name),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
