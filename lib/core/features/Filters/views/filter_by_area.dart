import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/components/filter_wide_card.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Repositories/filters_repo.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/root.dart';

class FilterByArea extends StatefulWidget {
  final String area;

  const FilterByArea({super.key, required this.area});

  @override
  State<FilterByArea> createState() => _FilterByAreaState();
}

class _FilterByAreaState extends State<FilterByArea> {
  Future<bool> timeout = Future.delayed(const Duration(seconds: 2), () => true);
  List<FilterModel> Areas = [];

  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _fetchData() async {
    try {
      final response = await FiltersRepo().FilterByArea(widget.area);
      setState(() {
        Areas = response;
      });
    } catch (e) {
      throw ApiError(message: '(FilterByArea) Failed to load data: $e');
    }
  }

  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const Root(count: 1)),
            );
          },
        ),
        title: Text(
          'Meals with ${widget.area}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Areas.isEmpty
          ? FutureBuilder<bool>(
              future: timeout,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.SelectedColor,
                    ),
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.error,
                        color: AppColors.SelectedColor,
                        size: 50,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No meals found for this area.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: Areas.length,
              itemBuilder: (context, index) {
                final area = Areas[index];
                return FilterWideCard(
                  model: area,
                  In: widget.area,
                  filterType: 'area',
                );
              },
            ),
    );
  }
}
