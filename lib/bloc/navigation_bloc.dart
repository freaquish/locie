import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/navigation_stack.dart';
import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';
import 'package:locie/repo/store_view_repo.dart';

class NavigationState {}

class TransitionState extends NavigationState {}

class LoadingState extends NavigationState {}

class NavigatedToCategorySelection extends NavigationState {}

class NavigatedToCreateStore extends NavigationState {}

class NotItemFound extends NavigationState {}

class NavigatedToEditStore extends NavigationState {
  final Store store;
  NavigatedToEditStore(this.store);
}

class NavigatedToCreateListing extends NavigationState {
  final Category category;
  NavigatedToCreateListing(this.category);
}

class NavigatedToEditingListing extends NavigationState {
  final Listing listing;
  NavigatedToEditingListing(this.listing);
}

class ShowingParticularItemView extends NavigationState {
  final Listing listing;
  final bool isEditable;
  ShowingParticularItemView(this.listing, {this.isEditable = false});
}

class NavigatedToHome extends NavigationState {
  final bool isStoreExists;
  NavigatedToHome({this.isStoreExists = false});
}

class MaterialBuilder<T> extends NavigationState {
  final T route;
  MaterialBuilder(this.route);
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(TransitionState());
  NavigationStack route = NavigationStack();
  LocalStorage localStorage = LocalStorage();

  void push(NavigationEvent event) {
    route.push(event);
    // print(route.current());
    add(route.current());
  }

  void pop() {
    // print(route.length);
    route.pop();
    print(route.length);
    if (route.length > 0) {
      this..add(route.current());
    } else {
      this..add(NavigateToHome());
    }
  }

  void replace(NavigationEvent event) {
    route.replace(event);
    this..add(route.current());
  }

  void pushEventList(List<NavigationEvent> events) {
    route.pushList(events);
    this..add(route.current());
  }

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    await localStorage.init();
    print(route.length);
    if (event is NavigateToSelectCategory) {
      yield NavigatedToCategorySelection();
    } else if (event is NavigateToCreateListing) {
      yield NavigatedToCreateListing(event.category);
    } else if (event is NavigateToAuthentication) {
      yield TransitionState();
    } else if (event is NavigateToHome) {
      bool isStoreExists = localStorage.prefs.containsKey("sid");
      yield NavigatedToHome(isStoreExists: isStoreExists);
    } else if (event is NavigateToCreateStore) {
      yield NavigatedToCreateStore();
    } else if (event is NavigateToEditListing) {
      yield NavigatedToEditingListing(event.listing);
    } else if (event is MaterialProviderRoute) {
      yield MaterialBuilder(event.route);
    } else if (event is LaunchItemView) {
      yield LoadingState();
      Listing listing = await StoreViewRepo().fetchItem(event.lid);
      bool isEditable = localStorage.prefs.containsKey("sid") &&
          (localStorage.prefs.getString("sid") == listing.store);
      if (listing == null) {
        yield NotItemFound();
      } else {
        yield ShowingParticularItemView(listing, isEditable: isEditable);
      }
    } else if (event is NavigateToEditStore) {
      print(event.store.toString() + "nb");
      yield NavigatedToEditStore(event.store);
    }
  }
}
