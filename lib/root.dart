import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/data/Repositories/filters_repo.dart';
import 'package:mealdb_application/core/features/Filters/views/meal_details_page.dart';
import 'package:mealdb_application/core/features/home/components/listingBarComponents/listing_bar.dart';
import 'package:mealdb_application/core/features/home/components/search_bar.dart';
import 'package:mealdb_application/core/features/home/views/all_areas_page.dart';
import 'package:mealdb_application/core/features/home/views/all_categories_page.dart';
import 'package:mealdb_application/core/features/home/views/all_ingredients_page.dart';
import 'package:mealdb_application/core/shared/custom_text.dart';

class Root extends StatefulWidget {
  const Root({super.key, this.count = 0});
  final int count;

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    counter = widget.count;
  }

  final TextEditingController searchController = TextEditingController();

  void _onListingOptionSelected(int index) {
    setState(() {
      counter = index;
    });
  }

  Future<void> _searchMeal(String name) async {
    if (name.isEmpty) return;

    final meals = await FiltersRepo().searchMeals(name);
    if (!mounted) return;

    if (meals.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No meal found.')));
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MealDP(model: meals.first, from: name, filterType: 'search'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.primaryColor,
            automaticallyImplyLeading: false,
            centerTitle: true,
            expandedHeight: 10,
            collapsedHeight: 200,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            //mealdb
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'mealdb_icon',
                  child: Material(
                    color: Colors.transparent,
                    child: Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
                Hero(
                  tag: 'mealdb_text',
                  child: Material(
                    color: Colors.transparent,
                    child: CustomText(
                      text: 'mealdb',
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 130),
                //Search
                Search(
                  searchController: searchController,
                  onSubmitted: _searchMeal,
                ),
                SizedBox(height: 10),
                //ListingBar
                ListingBar(
                  selectedIndex: counter,
                  onOptionSelected: _onListingOptionSelected,
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            child: IndexedStack(
              index: counter,
              children: [AllIngredientsPage(), AllAreasPage(), AllCategories()],
            ),
          ),
        ],
      ),
    );
  }
}
