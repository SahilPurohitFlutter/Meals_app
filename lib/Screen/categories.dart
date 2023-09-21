import 'package:demoadvancemeal/Screen/meals.dart';
import 'package:demoadvancemeal/data/dummy_data.dart';
import 'package:demoadvancemeal/model/category.dart';
import 'package:demoadvancemeal/model/meal.dart';
import 'package:demoadvancemeal/widgets/Category_grid_item.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key,
      required this.onToggelFavourit,
      required this.availableMeals});

  final void Function(Meal meal) onToggelFavourit;
  final List<Meal> availableMeals;

  void _selectCategory(BuildContext context, Category category) {
    final filterMeals = availableMeals
        .where(
          (meal) => meal.categories.contains(category.id),
        )
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filterMeals,
          onToggelFavourit: onToggelFavourit,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectCategory(context, category);
            },
          )
      ],
    );
  }
}
