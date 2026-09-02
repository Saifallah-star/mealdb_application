import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
import 'package:mealdb_application/core/features/Filters/views/meal_details_page.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_cubit.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_state.dart';
import 'package:mealdb_application/core/features/favorites__Local/components/favorite_meal_card.dart';
import 'package:mealdb_application/core/utils/pref_helper.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final userId = await PrefHelper.getUserId();
    if (mounted) {
      setState(() {
        _userId = userId;
      });
      if (userId != null && userId.isNotEmpty) {
        context.read<FavoritesCubit>().loadFavorites(userId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Favorite Meals',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _userId == null || _userId!.isEmpty
          ? _buildGuestView()
          : BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                if (state is FavoritesLoading || state is FavoritesInitial) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.SelectedColor,
                    ),
                  );
                }

                if (state is FavoritesError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.errorColor,
                            size: 50,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadFavorites,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is FavoritesLoaded) {
                  if (state.favorites.isEmpty) {
                    return _buildEmptyView();
                  }

                  return RefreshIndicator(
                    color: AppColors.SelectedColor,
                    backgroundColor: Colors.white,
                    onRefresh: _loadFavorites,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      itemCount: state.favorites.length,
                      itemBuilder: (context, index) {
                        final meal = state.favorites[index];
                        return FavoriteMealCard(
                          meal: meal,
                          onTap: () {
                            final filterModel = FilterModel(
                              id: meal.id ?? '',
                              name: meal.name ?? '',
                              imageUrl: meal.imageUrl ?? '',
                              Area: meal.Area ?? '',
                              Country: meal.Country ?? '',
                            );

                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => MealDP(
                                  model: filterModel,
                                  from: 'Favorites',
                                  filterType: 'favorites',
                                ),
                              ),
                            );
                          },
                          onToggleFavorite: () {
                            if (_userId != null && _userId!.isNotEmpty) {
                              context
                                  .read<FavoritesCubit>()
                                  .toggleFavorite(meal, _userId!);
                            }
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              color: AppColors.SelectedColor.withValues(alpha: 0.5),
              size: 70,
            ),
            const SizedBox(height: 16),
            const Text(
              'No Favorite Meals Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.SelectedColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse meals and press the heart icon to save your favorites here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.lock_outline,
              color: AppColors.SelectedColor,
              size: 60,
            ),
            SizedBox(height: 16),
            Text(
              'Please log in to view your favorite meals.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.SelectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
