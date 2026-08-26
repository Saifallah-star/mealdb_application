import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/home/Cubit/Ingredients/ingredients_cubit.dart';
import 'package:mealdb_application/core/features/home/Cubit/Ingredients/ingredients_states.dart';
import 'package:mealdb_application/core/features/home/components/meal_card.dart';
import 'package:mealdb_application/core/features/home/data/models/all_Ingredients_model.dart';
import 'package:shimmer/shimmer.dart';

class AllIngredientsPage extends StatefulWidget {
  const AllIngredientsPage({super.key});

  @override
  State<AllIngredientsPage> createState() => _AllIngredientsPageState();
}

class _AllIngredientsPageState extends State<AllIngredientsPage> {
  @override
  void initState() {
    super.initState();
    context.read<IngredientsCubit>().loadIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IngredientsCubit, IngredientsStates>(
      listener: (context, state) {
        if (state is IngredientsError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is IngredientsError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: context.read<IngredientsCubit>().loadIngredients,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final items = state is IngredientsLoaded
            ? state.ingredients
            : <AllIngredientsModel>[];
        final isLoading =
            state is IngredientsLoading || state is IngredientsInitial;

        if (isLoading) {
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
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildLoadingCard(),
                    childCount: 8,
                  ),
                ),
              ),
            ],
          );
        }

        return RefreshIndicator(
          color: AppColors.SelectedColor,
          backgroundColor: Colors.white,
          displacement: 2.0,
          strokeWidth: 3.0,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: context.read<IngredientsCubit>().loadIngredients,
          child: CustomScrollView(
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
                    final ingredient = items[index];
                    return MealCard(
                      mealName: ingredient.name,
                      mealImage: ingredient.ingredientImage,
                      description: ingredient.type,
                    );
                  }, childCount: items.length),
                ),
              ),
            ],
          ),
        );
      },
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
