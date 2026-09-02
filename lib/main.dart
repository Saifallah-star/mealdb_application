import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/Cubit/filter_cubit.dart';
import 'package:mealdb_application/core/features/auth/cubit/auth/auth_cubit.dart';
import 'package:mealdb_application/core/features/auth/data/repo/user_dao.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_cubit.dart';
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
        BlocProvider(create: (context) => AuthCubit(UserDao())),
        BlocProvider(create: (context) => FavoritesCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: AppColors.primaryColor,
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentTextStyle: const TextStyle(color: Colors.white),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
