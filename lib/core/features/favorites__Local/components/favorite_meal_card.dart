import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/meal_model.dart';

class FavoriteMealCard extends StatelessWidget {
  final MealModel meal;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const FavoriteMealCard({
    super.key,
    required this.meal,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    meal.imageUrl ?? '',
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
                    child: IconButton(
                      icon: const CircleAvatar(
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
                      ),
                      onPressed: onToggleFavorite,
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
                      meal.name ?? 'Unknown',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (meal.Area != null && meal.Area!.isNotEmpty) ...[
                Row(
                  children: [
                    const Text(
                      'Area: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        meal.Area!,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (meal.Country != null && meal.Country!.isNotEmpty) ...[
                Row(
                  children: [
                    const Text(
                      'Country: ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        meal.Country!,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
