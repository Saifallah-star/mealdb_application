import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/meal_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Repositories/filters_repo.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_Ingredient.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_area.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_category.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_cubit.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_state.dart';
import 'package:mealdb_application/core/utils/pref_helper.dart';
import 'package:mealdb_application/root.dart';
import 'package:mealdb_application/core/network/dio_error.dart';

class MealDP extends StatefulWidget {
  final FilterModel model;
  final String from;
  final String filterType;
  const MealDP({
    super.key,
    required this.model,
    required this.from,
    required this.filterType,
  });

  @override
  State<MealDP> createState() => _MealDPState();
}

class _MealDPState extends State<MealDP> {
  MealModel? mealModel;
  String? _userId;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final userId = await PrefHelper.getUserId();
    if (mounted) {
      setState(() {
        _userId = userId;
      });
      if (userId != null && userId.isNotEmpty) {
        final cubit = context.read<FavoritesCubit>();
        if (cubit.state is FavoritesInitial) {
          cubit.loadFavorites(userId);
        }
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final userId = _userId ?? await PrefHelper.getUserId();
    if (userId == null || userId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to manage favorites.'),
            backgroundColor: AppColors.errorColor,
          ),
        );
      }
      return;
    }

    final meal = mealModel ??
        MealModel(
          id: widget.model.id,
          name: widget.model.name,
          imageUrl: widget.model.imageUrl,
          Area: widget.model.Area,
          Country: widget.model.Country,
        );

    if (mounted) {
      context.read<FavoritesCubit>().toggleFavorite(meal, userId);
    }
  }

  Future<void> fetchMealDetails() async {
    try {
      final response = await FiltersRepo().getMealDetails(widget.model.id);
      if (mounted) {
        setState(() {
          mealModel = response;
        });
      }
    } catch (e) {
      throw ApiError(message: '(MealDP) Failed to load meal details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: AppColors.SelectedColor,
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.SelectedColor),
          onPressed: () {
            NavigateBack(context);
          },
        ),
        title: const Text('Meal Details'),
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              final isFavorite = state is FavoritesLoaded &&
                  state.favorites.any((m) => m.id == widget.model.id);

              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : AppColors.SelectedColor,
                ),
                onPressed: _toggleFavorite,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.model.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.5)),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //w meal name === === === === === === === === === === === === ===
                const SizedBox(height: 30),
                Text(
                  textAlign: TextAlign.center,
                  widget.model.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                ///w Area === === === === === === === === === === === ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Area: ',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      mealModel?.Area ?? 'Loading...',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ///w Country === === === === === === === === === === === ===
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Country: ',
                      style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      mealModel?.Country ?? 'Loading...',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                //w Instructions === === === === === === === === === === === ===
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    mealModel?.Instructions ?? 'No instructions available.',
                    style: const TextStyle(fontSize: 17, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                //! Youtube link === === === === === === === === === === === ===
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const Text(
                        textAlign: TextAlign.center,
                        'Youtube',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 252, 81, 69),
                        ),
                      ),
                      Text(
                        mealModel?.YoutubeLink ?? 'No Youtube link available.',
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                //w Ingredients List === === === === === === === === === === === ===
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(8),
                  //w Ingredients and Measures List === === === === === === ===
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Ingredients List
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            textAlign: TextAlign.center,
                            'Ingredients',
                            style: TextStyle(
                              fontSize: 19,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          for (var ingredient in mealModel?.Ingredients ?? [])
                            Text(
                              ingredient,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                      // Measures List
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            textAlign: TextAlign.center,
                            'Measures',
                            style: TextStyle(
                              fontSize: 19,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          for (var measure in mealModel?.Measures ?? [])
                            Text(
                              measure,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void NavigateBack(BuildContext context) {
    if (widget.filterType == 'favorites') {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => Root(H_index: 0, navIndex: 0)));
    } else if (widget.filterType == 'search') {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => Root()));
    } else if (widget.filterType == 'category') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FilterByCategory(name: widget.from),
        ),
      );
    } else if (widget.filterType == 'area') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FilterByArea(area: widget.from),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => FilterByIngredient(mealName: widget.from),
        ),
      );
    }
  }
}

