import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/area_model.dart';
import 'package:mealdb_application/core/features/Filters/data/Repositories/filters_repo.dart';
import 'package:mealdb_application/core/features/home/data/models/all_areas_model.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/root.dart';

class FilterByArea extends StatefulWidget {
  final AllAreasModel area;

  const FilterByArea({super.key, required this.area});

  @override
  State<FilterByArea> createState() => _FilterByAreaState();
}

class _FilterByAreaState extends State<FilterByArea> {
  Future<bool> timeout = Future.delayed(const Duration(seconds: 2), () => true);
  List<AreaModel> Areas = [];

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
      final response = await FiltersRepo().FilterByArea(widget.area.name);
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
          'Meals with ${widget.area.name}',
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
                return Container(
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
                    title: Column(
                      children: [
                        Image.network(
                          area.imageUrl,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                area.name,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                area.Area,
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                area.Country,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
