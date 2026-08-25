import 'package:flutter/material.dart';
import 'package:mealdb_application/core/features/home/components/meal_card.dart';
import 'package:mealdb_application/core/features/home/data/models/all_Ingredients_model.dart';
import 'package:mealdb_application/core/features/home/data/Repository/home_repo.dart';
import 'package:shimmer/shimmer.dart';

class AllIngredientsPage extends StatefulWidget {
  const AllIngredientsPage({super.key});

  @override
  State<AllIngredientsPage> createState() => _AllIngredientsPageState();
}

class _AllIngredientsPageState extends State<AllIngredientsPage> {
  final TextEditingController searchController = TextEditingController();
  final AllIngredientsModel allIngredientsModel = AllIngredientsModel(
    idIngredient: '',
    name: '',
    type: '',
    ingredientImage: '',
  );

  bool isLoading = true;
  List<AllIngredientsModel> Ingredients = [];

  Future<void> fetchIngredients() async {
    try {
      final homeRepo = HomeRepo();
      final ingredients = await homeRepo.getIngredients();
      if (!mounted) return;
      setState(() {
        Ingredients = ingredients;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
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
    final items = isLoading ? List.generate(8, (_) => 0) : Ingredients;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (isLoading) {
                return _buildLoadingCard();
              }
              final ingredient = items[index] as AllIngredientsModel;
              return MealCard(
                mealName: ingredient.name,
                mealImage: ingredient.ingredientImage,
                description: ingredient.type,
              );
            }, childCount: items.length),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 110,
              width: 110,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              ),
            ),
            SizedBox(height: 12),
            SizedBox(
              height: 16,
              width: 90,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
