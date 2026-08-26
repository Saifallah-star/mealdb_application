import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/views/filter_by_area.dart';
import 'package:mealdb_application/core/features/home/Cubit/Areas/areas-states.dart';
import 'package:mealdb_application/core/features/home/Cubit/Areas/areas_cubit.dart';

class AllAreasPage extends StatefulWidget {
  const AllAreasPage({super.key});

  @override
  State<AllAreasPage> createState() => _AllAreasPageState();
}

class _AllAreasPageState extends State<AllAreasPage> {
  @override
  void initState() {
    super.initState();
    context.read<AreasCubit>().loadAreas();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AreasCubit, AreasStates>(
      builder: (context, state) {
        if (state is AreasError) {
          return _buildErrorView(state.message);
        }
        if (state is AreasLoading || state is AreasInitial) {
          return _buildLoadingView();
        }

        final areas = (state as AreasLoaded).areas;
        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            color: AppColors.SelectedColor,
            backgroundColor: Colors.white,
            displacement: 2.0,
            strokeWidth: 3.0,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: context.read<AreasCubit>().loadAreas,
            child: ListView.builder(
              padding: const EdgeInsets.all(12.0),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: areas.length,
              itemBuilder: (context, index) {
                final area = areas[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 15.0,
                  ),
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
                    tileColor: Colors.grey.withValues(alpha: 0.1),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: AppColors.SelectedColor,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => FilterByArea(area: area.name),
                        ),
                      );
                    },
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Area:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 35),
                            Expanded(
                              child: Text(
                                area.name,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Country:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                area.country,
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
          ),
        );
      },
    );
  }

  Widget _buildLoadingView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: 8,
        itemBuilder: (context, index) => Container(
          height: 84,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48),
            const SizedBox(height: 12),
            Text(message),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                context.read<AreasCubit>().loadAreas();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
