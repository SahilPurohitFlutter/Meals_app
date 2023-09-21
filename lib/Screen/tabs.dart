import 'package:demoadvancemeal/Screen/categories.dart';
import 'package:demoadvancemeal/Screen/filters.dart';
import 'package:demoadvancemeal/Screen/meals.dart';
import 'package:demoadvancemeal/data/dummy_data.dart';
import 'package:demoadvancemeal/model/meal.dart';
import 'package:demoadvancemeal/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegen: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favouriteMeals = [];
  Map<Filter, bool> _selectdFilters = kInitialFilters;

  void _showInfoMessage(String Message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(Message),
      ),
    );
  }

  void _toggelMealFavouriteStetus(Meal meal) {
    final isExiting = _favouriteMeals.contains(meal);
    if (isExiting) {
      setState(() {
        _favouriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favourit');
    } else {
      setState(() {
        _favouriteMeals.add(meal);
      });
      _showInfoMessage('Meal added to the favourit');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setscreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(currentFilters: _selectdFilters,),
        ),
      );
      setState(() {
        _selectdFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectdFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectdFilters[Filter.glutenFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectdFilters[Filter.glutenFree]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectdFilters[Filter.glutenFree]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggelFavourit: _toggelMealFavouriteStetus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favouriteMeals,
        onToggelFavourit: _toggelMealFavouriteStetus,
      );
      activePageTitle = 'Favourite';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setscreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }
}
