import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/pages/authentication.dart';
import 'package:locie/pages/category.dart';
import 'package:locie/pages/listing_widget.dart';
import 'package:locie/pages/store_widgets.dart';
import 'package:locie/views/Store_view/product_view.dart';
import 'package:locie/views/home_page.dart';

class NavigationProvider extends StatelessWidget {
  final NavigationEvent event;
  // final NavigationBloc bloc;
  NavigationProvider({
    this.event,
  });

  @override
  Widget build(BuildContext context) {
    NavigationBloc bloc = NavigationBloc();
    // bloc.route.bloc = bloc;
    NavigationEvent _event = NavigateToAuthentication();
    if (event != null) {
      bloc.route.pushList([event, _event]);
    }
    return Container(
      child: BlocProvider<NavigationBloc>(
        create: (context) => bloc..add(_event),
        child: NavigationBuilder(),
      ),
    );
  }
}

class NavigationBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NavigationBloc bloc = BlocProvider.of<NavigationBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<NavigationBloc, NavigationState>(
        cubit: bloc,
        builder: (context, state) {
          // print(state);
          if (state is NavigatedToCategorySelection) {
            return CategoryProvider();
          } else if (state is NavigatedToCreateListing) {
            return ListingOperationViewProvider(
              category: state.category,
            );
          } else if (state is TransitionState) {
            return AuthenticationWidget();
          } else if (state is NavigatedToCreateStore) {
            return CreateOrEditStoreWidget();
          } else if (state is NavigatedToEditingListing) {
            return ListingOperationViewProvider(
              listing: state.listing,
            );
          } else if (state is MaterialBuilder) {
            return state.route;
          } else if (state is NavigatedToHome) {
            return HomePageView(
              isStoreExists: state.isStoreExists,
            );
          } else if (state is ShowingParticularItemView) {
            return SingleProductViewWidget(
              listing: state.listing,
              isEditable: state.isEditable,
            );
          } else if (state is NavigatedToEditStore) {
            print(state.store.toString() + "nt");
            return CreateOrEditStoreWidget(
              store: state.store,
            );
          }
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
