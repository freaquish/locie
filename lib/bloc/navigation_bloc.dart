import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/helper/navigation_stack.dart';
import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';

class NavigationState {}

class TransitionState extends NavigationState {}

class NavigatedToCategorySelection extends NavigationState {}

class NavigatedToCreateStore extends NavigationState {}

class NavigatedToCreateListing extends NavigationState {
  final Category category;
  NavigatedToCreateListing(this.category);
}

class NavigatedToEditingListing extends NavigationState {
  final Listing listing;
  NavigatedToEditingListing(this.listing);
}

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(TransitionState());
  NavigationStack route = NavigationStack();

  void push(NavigationEvent event) {
    route.push(event);
    this..add(route.current());
  }

  void pop(NavigationEvent event) {
    route.pop();
    if (route.length > 0) {
      this..add(route.current());
    }
  }

  void replace(NavigationEvent event) {
    route.replace(event);
    this..add(route.current());
  }

  @override
  Stream<NavigationState> mapEventToState(NavigationEvent event) async* {
    if (event is NavigateToSelectCategory) {
      yield NavigatedToCategorySelection();
    } else if (event is NavigateToCreateListing) {
      yield NavigatedToCreateListing(event.category);
    } else if (event is NavigateToAuthentication) {
      yield TransitionState();
    } else if (event is NavigateToHome) {
      yield NavigatedToCategorySelection();
    } else if (event is NavigateToCreateStore) {
      yield NavigatedToCreateStore();
    } else if(event is NavigateToEditListing){
      yield NavigatedToEditingListing(event.listing);
    }
  }
}
