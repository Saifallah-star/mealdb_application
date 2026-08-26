import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mealdb_application/core/constants/colors.dart';
import 'package:mealdb_application/core/features/Filters/Cubit/filter_cubit.dart';
import 'package:mealdb_application/core/features/Filters/Cubit/filter_states.dart';
import 'package:mealdb_application/core/features/Filters/components/filter_wide_card.dart';
import 'package:mealdb_application/root.dart';

class FilterByIngredient extends StatefulWidget {
  const FilterByIngredient({super.key, required this.mealName});
  final String mealName;

  @override
  State<FilterByIngredient> createState() => _FilterByIngredientState();
}

class _FilterByIngredientState extends State<FilterByIngredient> {
  @override
  void initState() {
    super.initState();
    context.read<FilterCubit>().FilterByIngredient(widget.mealName);
  }

  @override
  void didUpdateWidget(covariant FilterByIngredient oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mealName != widget.mealName) {
      context.read<FilterCubit>().FilterByIngredient(widget.mealName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilterCubit, FilterStates>(
      listener: (context, state) {
        if (state is FilterError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (BuildContext context, FilterStates state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Root(count: 0)),
                );
              },
            ),
            title: Text(
              'Meals with ${widget.mealName}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(FilterStates state) {
    if (state is FilterLoading || state is FilterInitial) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.SelectedColor),
      );
    }

    if (state is FilterLoaded) {
      return ListView.builder(
        itemCount: state.response.length,
        itemBuilder: (context, index) {
          final ingredient = state.response[index];
          return FilterWideCard(
            model: ingredient,
            In: widget.mealName,
            filterType: 'ingredient',
          );
        },
      );
    }

    if (state is FilterEmpty) {
      return const _FilterStateView(
        icon: Icons.info_outline,
        message: 'No meals found for this ingredient.',
      );
    }

    if (state is FilterError) {
      return _FilterStateView(
        icon: Icons.error_outline,
        message: state.message,
        onRetry: () {
          context.read<FilterCubit>().FilterByIngredient(widget.mealName);
        },
      );
    }

    return const SizedBox.shrink();
  }
}

class _FilterStateView extends StatelessWidget {
  const _FilterStateView({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.SelectedColor, size: 50),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
