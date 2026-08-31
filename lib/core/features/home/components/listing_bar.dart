import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';

class ListingBar extends StatelessWidget {
  ListingBar({
    super.key,
    required this.selectedIndex,
    required this.onOptionSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onOptionSelected;
  Color TextColor = AppColors.BlackTextColor;
  final List<String> listingOptions = [
    'all Ingredients',
    'all Areas',
    'all Categories',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 12.0),
      child: Row(
        children: List.generate(
          listingOptions.length,
          (index) => GestureDetector(
            onTap: () => onOptionSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: selectedIndex == index
                    ? AppColors.SelectedColor
                    : AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(color: AppColors.secondaryColor),
              ),
              child: Text(
                listingOptions[index],
                style: TextStyle(
                  color: selectedIndex == index
                      ? AppColors.secondaryColor
                      : AppColors.SelectedColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
