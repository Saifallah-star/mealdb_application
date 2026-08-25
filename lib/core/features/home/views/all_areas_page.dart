import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_area.dart';
import 'package:mealdb_application/core/features/home/data/Repository/home_repo.dart';
import 'package:mealdb_application/core/features/home/data/models/all_areas_model.dart';
import 'package:mealdb_application/core/network/dio_error.dart';
import 'package:mealdb_application/core/network/dio_exceptions.dart';

class AllAreasPage extends StatefulWidget {
  const AllAreasPage({super.key});

  @override
  State<AllAreasPage> createState() => _AllAreasPageState();
}

class _AllAreasPageState extends State<AllAreasPage> {
  List<AllAreasModel> areas = [];

  Future<void> _fetchData() async {
    try {
      final response = await HomeRepo().getAllAreas();
      setState(() {
        areas = response;
      });
    } on DioException catch (e) {
      ApiException.handleException(e);
    } catch (e) {
      throw ApiError(message: '(AllAreasPage) Failed to load data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: areas.length,
        itemBuilder: (context, index) {
          final area = areas[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
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
              textColor: AppColors.SelectedColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.grey.withOpacity(0.1),
              // tileColor: Colors.white,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.network(
                  'https://www.vecteezy.com/free-vector/chef-hat',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.restaurant_menu,
                      color: AppColors.SelectedColor,
                    );
                  },
                ),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => FilterByArea(area: area),
                  ),
                );
              },
              // Area and Country info
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // area info
                  Row(
                    children: [
                      Text(
                        'Area:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 35),
                      Text(area.name),
                    ],
                  ),
                  // country info
                  Row(
                    children: [
                      Text(
                        'Country:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 10),
                      Text(area.country),
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
