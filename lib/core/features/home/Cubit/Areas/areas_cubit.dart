import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/features/home/Cubit/Areas/areas-states.dart';
import 'package:mealdb_application/core/features/home/data/Repository/home_repo.dart';

class AreasCubit extends Cubit<AreasStates> {
  AreasCubit() : super(AreasInitial());

  Future<void> loadAreas() async {
    emit(AreasLoading());
    try {
      final areas = await HomeRepo().getAllAreas();
      emit(AreasLoaded(areas));
    } catch (_) {
      emit(AreasError('Unable to load areas. Please try again.'));
    }
  }
}
