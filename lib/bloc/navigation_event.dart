import 'package:locie/models/category.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/models/store.dart';

class NavigationEvent {}

class NavigateToAuthentication extends NavigationEvent {}

class NavigateToHome extends NavigationEvent {
  final bool isStoreExists;
  NavigateToHome({this.isStoreExists = false});
}

class LaunchItemView extends NavigationEvent {
  final String lid;
  LaunchItemView(this.lid);
}

class NavigateToSelectCategory extends NavigationEvent {}

class NavigateToCreateListing extends NavigationEvent {
  final Category category;
  NavigateToCreateListing(this.category);
}

class NavigateToCreateStore extends NavigationEvent {}

class NavigateToEditStore extends NavigationEvent {
  final Store store;
  NavigateToEditStore(this.store);
}

class MaterialProviderRoute<T> extends NavigationEvent {
  final T route;
  MaterialProviderRoute({this.route});

  Type get type => T;
}

class NavigateToEditListing extends NavigationEvent {
  final Listing listing;
  NavigateToEditListing({this.listing});
}

// class NavigateToHome extends NavigationEvent {}

class NavigateToMyStore extends NavigationEvent {}

class NavigateToMyWorks extends NavigationEvent {}

class NavigateToMyListings extends NavigationEvent {}
