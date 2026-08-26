import 'package:mealdb_application/core/features/Filters/data/Models/filter_model.dart';

abstract class FilterStates {}

class FilterInitial extends FilterStates {}

class FilterLoading extends FilterStates {}

class FilterLoaded extends FilterStates {
  final List<FilterModel> response;
  FilterLoaded(this.response);
}

class FilterError extends FilterStates {
  final String message;
  FilterError(this.message);
}

class FilterEmpty extends FilterStates {}
