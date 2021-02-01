import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/category.dart';
import 'package:locie/helper/firestore_query.dart';

class CategoryState {}

class LoadingStates extends CategoryState {}

class InitialState extends LoadingStates {}

class FetchingCategory extends LoadingStates {}

class FetchedCategories extends CategoryState {
  final List<Category> categories;
  FetchedCategories(this.categories);
}

class ShowingCategorySelectionPage extends CategoryState {
  final List<Category> category;
  ShowingCategorySelectionPage({this.category});
}

class ShowingCategoryViewInPage extends CategoryState {
  final List<Category> categories;
  ShowingCategoryViewInPage(this.categories);
}

class ShowingAddNewCategoryPage extends CategoryState {
  final String current;
  ShowingAddNewCategoryPage([this.current]);
}

class CreatingCategegory extends LoadingStates {}

class CreatedCategory extends CategoryState {
  final Category category;
  CreatedCategory(this.category);
}

class CategoryEvent {}

class FetchCategories extends CategoryEvent {
  final String current;
  final String store;
  FetchCategories({this.current, this.store});
}

class InitiateCategorySelection extends CategoryEvent {
  final String current;
  final bool isLoaded;
  InitiateCategorySelection({this.current, this.isLoaded});
}

class InitiateAddNewCategory extends CategoryEvent {
  final String current;
  InitiateAddNewCategory(this.current);
}

class ProceedToNextCategoryPage extends CategoryEvent {
  final String current;
  ProceedToNextCategoryPage(this.current);
}

class ProceedToLastCategoryPage extends CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final Category category;
  CreateCategory(this.category);
}

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(InitialState());

  List<List<Category>> categoriesAcrossPages = [];
  LocalStorage localStorage = LocalStorage();
  FireStoreQuery storeQuery = FireStoreQuery();

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    if (event is InitiateCategorySelection) {
      yield ShowingCategorySelectionPage();

      List<Category> categories = [];
      if (event.current == null) {
        categories = await storeQuery.fetchCategories();
      } else {
        var sid = localStorage.prefs.getString("sid");
        categories = await storeQuery.fetchCategories(
            current: event.current, store: sid);
      }
      // print(categories);
      categoriesAcrossPages.add(categories);

      yield ShowingCategorySelectionPage(
          category: categoriesAcrossPages[categoriesAcrossPages.length - 1]);
    } else if (event is ProceedToNextCategoryPage) {
      var sid = localStorage.prefs.getString("sid");
      var categories =
          await storeQuery.fetchCategories(current: event.current, store: sid);
      categoriesAcrossPages.add(categories);
      yield ShowingCategorySelectionPage(
          category: categoriesAcrossPages[categoriesAcrossPages.length - 1]);
    } else if (event is ProceedToLastCategoryPage) {
      categoriesAcrossPages.removeLast();
      yield ShowingCategorySelectionPage(
          category: categoriesAcrossPages[categoriesAcrossPages.length - 1]);
    } else if (event is InitiateAddNewCategory) {
      yield ShowingAddNewCategoryPage(event.current);
    } else if (event is CreateCategory) {
      yield CreatingCategegory();
      Category category = await storeQuery.createNewCategory(event.category);
      categoriesAcrossPages[categoriesAcrossPages.length - 1].add(category);
      yield ShowingCategorySelectionPage(
          category: categoriesAcrossPages[categoriesAcrossPages.length - 1]);
    }
  }
}
