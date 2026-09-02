import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/meal_model.dart';
import 'package:mealdb_application/core/features/Filters/views/meal_details_page.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_cubit.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_state.dart';
import 'package:mealdb_application/core/utils/pref_helper.dart';

class FilterWideCard extends StatefulWidget {
  final FilterModel model;
  final String In;
  final String filterType;
  const FilterWideCard({
    super.key,
    required this.model,
    required this.In,
    required this.filterType,
  });
  @override
  State<FilterWideCard> createState() => _FilterWideCardState();
}

class _FilterWideCardState extends State<FilterWideCard> {
  late String fromPage;
  String? _userId;

  @override
  void initState() {
    super.initState();
    fromPage = widget.model.toString();
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

    final meal = MealModel(
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MealDP(
              model: widget.model,
              from: widget.In,
              filterType: widget.filterType,
            ),
          ),
        );
      },
      child: Container(
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
          tileColor: AppColors.primaryColor.withValues(alpha: 0.08),
          textColor: Colors.black87,
          title: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.model.imageUrl,
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
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 155,
                    bottom: 155,
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, state) {
                        final isFavorite = state is FavoritesLoaded &&
                            state.favorites.any((m) => m.id == widget.model.id);

                        return IconButton(
                          icon: isFavorite
                              ? const CircleAvatar(
                                  backgroundColor: Color.fromARGB(
                                    221,
                                    255,
                                    255,
                                    255,
                                  ),
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                )
                              : const CircleAvatar(
                                  backgroundColor: Color.fromARGB(
                                    221,
                                    255,
                                    255,
                                    255,
                                  ),
                                  child: Icon(Icons.favorite_border),
                                ),
                          onPressed: _toggleFavorite,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Text(
                    'Name: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      widget.model.name,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // Area
              Row(
                children: [
                  const Text(
                    'Area: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      widget.model.Area,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // Country
              Row(
                children: [
                  const Text(
                    'Country: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Text(
                      widget.model.Country,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
