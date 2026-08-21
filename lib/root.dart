import 'package:flutter/material.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/home/views/home_page.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final int _counter = 0;

  // void _incrementCounter() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: IndexedStack(index: _counter, children: [HomePage()]),
    );
  }
}
