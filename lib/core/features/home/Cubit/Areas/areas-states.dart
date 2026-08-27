import 'package:mealdb_application/core/features/home/data/models/all_areas_model.dart';

sealed class AreasStates {}

class AreasInitial extends AreasStates {}

class AreasLoading extends AreasStates {}

class AreasLoaded extends AreasStates {
  final List<AllAreasModel> areas;

  AreasLoaded(this.areas);
}

class AreasError extends AreasStates {
  final String message;

  AreasError(this.message);
}
