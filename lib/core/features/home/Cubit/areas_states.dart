import 'package:mealdb_application/core/features/home/data/models/all_areas_model.dart';

abstract class AreasState {}

class AreasInitial extends AreasState {}

class AreasLoading extends AreasState {}

class AreasLoaded extends AreasState {
  final List<AllAreasModel> areas;

  AreasLoaded(this.areas);
}

class AreasError extends AreasState {
  final String message;

  AreasError(this.message);
}
