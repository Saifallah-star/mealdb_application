import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/features/Filters/Cubit/filter_cubit.dart';
import 'package:mealdb_application/core/features/home/Cubit/Areas/areas_cubit.dart';
import 'package:mealdb_application/core/features/home/Cubit/Categories/categories_cubit.dart';
import 'package:mealdb_application/core/features/home/Cubit/Ingredients/ingredients_cubit.dart';
import 'package:mealdb_application/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => IngredientsCubit()),
        BlocProvider(create: (context) => CategoriesCubit()),
        BlocProvider(create: (context) => AreasCubit()),
        BlocProvider(create: (context) => FilterCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: Colors.deepPurple,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
