import 'package:locie/models/category.dart';

class CategoryState {}

class CategoryEvent {}

class FetchCategories extends CategoryEvent {
  final String current;
  final String store;
  final List<String> categories;
  FetchCategories({this.categories, this.current, this.store});
}

class InitiateCategorySelection extends CategoryEvent {
  final Function onSelect;
  InitiateCategorySelection(this.onSelect);
}

class InitiateAddNewCategory extends CategoryEvent {
  final String current;
  InitiateAddNewCategory(this.current);
}

class CreateCategory extends CategoryEvent {
  final Category category;
  CreateCategory(this.category);
}
