import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';

class NavigationEvent {}

class NavigateToAuthentication extends NavigationEvent {}

class NavigateToHome extends NavigationEvent {}

class NavigateToSelectCategory extends NavigationEvent {}

class NavigateToCreateListing extends NavigationEvent {
  final Category category;
  NavigateToCreateListing(this.category);
}

class NavigateToCreateStore extends NavigationEvent {}

class NavigateToEditStore extends NavigationEvent {}

class NavigateToEditListing extends NavigationEvent {
  final Listing listing;
  NavigateToEditListing({this.listing});
}

// class NavigateToHome extends NavigationEvent {}

class NavigateToMyStore extends NavigationEvent {}

class NavigateToMyWorks extends NavigationEvent {}

class NavigateToMyListings extends NavigationEvent {}
