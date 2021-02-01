import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';

class NavigationState {}

class NavigationEvent {}

class NavigateToAuthentication extends NavigationEvent {}

class NavigateToHome extends NavigationEvent {}

class NavigateToCreateListing extends NavigationEvent {}

class NavigateToCreateStore extends NavigationEvent {}

class NavigateToEditStore extends NavigationEvent {}

class NavigateToEditListing extends NavigationEvent {
  final Listing listing;
  NavigateToEditListing({this.listing});
}

class NavigateToMyStore extends NavigationEvent {}

class NavigateToMyWorks extends NavigationEvent {}

class NavigateToMyListings extends NavigationEvent {}
