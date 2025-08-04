import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetrian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegan: false,
        Filter.vegetrian: false,
      });

  void setFilters(Map<Filter, bool> chosenFilter) {
    state = chosenFilter;
  }

  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; is not allowed
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
      (ref) => FiltersNotifier(),
    );

final filterMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilter = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFilter[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilter[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilter[Filter.vegetrian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilter[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
