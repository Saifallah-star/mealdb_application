import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
import 'package:mealdb_application/core/features/Filters/views/meal_details_page.dart';

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
  @override
  void initState() {
    super.initState();
    fromPage = widget.model.toString();
  }

  // Initialize fromPage with the value from the model;
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
              const SizedBox(height: 8.0),
              // Name
              Row(
                children: [
                  Text(
                    'Name: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                  Text(
                    'Area: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
                  Text(
                    'Country: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
