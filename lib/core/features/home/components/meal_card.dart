import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/shared/custom_text.dart';

class MealCard extends StatelessWidget {
  final String mealName;
  final String mealImage;
  final String country;

  const MealCard({
    super.key,
    required this.mealName,
    required this.mealImage,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      shadowColor: Colors.black54,
      child: Column(
        children: [
          Image.network(mealImage, width: 130, height: 130),
          CustomText(text: mealName, fontSize: 16),
          CustomText(text: country, fontSize: 14),
        ],
      ),
    );
  }
}
