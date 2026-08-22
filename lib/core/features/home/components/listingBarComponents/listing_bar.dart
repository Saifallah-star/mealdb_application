import 'package:flutter/material.dart';

class ListingBar extends StatelessWidget {
  ListingBar({
    super.key,
    required this.selectedIndex,
    required this.onOptionSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onOptionSelected;

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
                    ? Colors.black
                    : Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                listingOptions[index],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
