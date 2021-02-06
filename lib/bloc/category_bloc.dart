import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/category.dart';
import 'package:locie/helper/firestore_query.dart';

class CategoryState {}

class LoadingStates extends CategoryState {}

class CommonCategoryError extends CategoryState {}

class InitialState extends LoadingStates {}

class RedirectToStoreCreation extends CategoryState {}

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

class CreateNewToSelection extends CategoryEvent {}

class ProceedToLastCategoryPage extends CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final Category category;
  CreateCategory(this.category);
}

class JumpBackToCategorySelection extends CategoryEvent {}

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(InitialState());

  List<List<Category>> categoriesAcrossPages = [];
  LocalStorage localStorage = LocalStorage();
  FireStoreQuery storeQuery = FireStoreQuery();

  // List<CategoryEvent> events = [];

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    // //printevent);
    try {
      await localStorage.init();
      if (event is InitiateCategorySelection) {
        if (!localStorage.prefs.containsKey("sid")) {
          yield RedirectToStoreCreation();
        } else {
          yield ShowingCategorySelectionPage();

          List<Category> categories = [];
          if (event.current == null) {
            categories = await storeQuery.fetchCategories();
          } else {
            var sid = localStorage.prefs.getString("sid");
            categories = await storeQuery.fetchCategories(
                current: event.current, store: sid);
          }
          // //printcategories);
          if (categories.isNotEmpty) {
            categoriesAcrossPages.add(categories);
          }

          yield ShowingCategorySelectionPage(
              category:
                  categoriesAcrossPages[categoriesAcrossPages.length - 1]);
        }
      } else if (event is ProceedToNextCategoryPage) {
        var sid = localStorage.prefs.getString("sid");
        //print'${event.current} $sid');
        var categories = await storeQuery.fetchCategories(
            current: event.current, store: sid);
        // //print'$categories ${event.current}');
        if (categories.isNotEmpty) {
          categoriesAcrossPages.add(categories);
        }
        //printcategoriesAcrossPages.length);
        // //printcategoriesAcrossPages[1].length);
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
        var parentExist =
            categoriesAcrossPages[categoriesAcrossPages.length - 1]
                .any((element) => category.parent == element.id);
        if (!parentExist) {
          categoriesAcrossPages[categoriesAcrossPages.length - 1].add(category);
        }
        yield ShowingCategorySelectionPage(
            category: categoriesAcrossPages[categoriesAcrossPages.length - 1]);
      } else if (event is CreateNewToSelection) {
        yield ShowingCategorySelectionPage(
            category: categoriesAcrossPages[categoriesAcrossPages.length - 1]);
      } else if (event is JumpBackToCategorySelection) {
        yield ShowingCategorySelectionPage(
            category: categoriesAcrossPages[categoriesAcrossPages.length - 1]);
      }
    } catch (e) {
      yield CommonCategoryError();
    }
  }
}
