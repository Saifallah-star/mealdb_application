import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_Ingredient.dart';
import 'package:mealdb_application/core/shared/custom_text.dart';

class MealCard extends StatelessWidget {
  final String mealName;
  final String? mealImage;
  final String? description;

  const MealCard({
    super.key,
    required this.mealName,
    this.mealImage,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => FilterByIngredient(mealName: mealName),
          ),
        );
      },
      child: Card(
        color: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: Colors.black54,
        child: Column(
          children: [
            mealImage != null
                ? Image.network(mealImage!, width: 130, height: 130)
                : Image.network(
                    'https://tenor.com/view/no-internet-bad-internet-internet-gif-5717777564739969668.gif',
                    width: 130,
                    height: 130,
                  ),
            CustomText(text: mealName, fontSize: 16),
            if (description != null) ...[
              CustomText(text: description!, fontSize: 14),
            ],
          ],
        ),
      ),
    );
  }
}
