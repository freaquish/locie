import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/pages/authentication.dart';
import 'package:locie/pages/category.dart';
import 'package:locie/pages/listing_widget.dart';
import 'package:locie/pages/store_widgets.dart';

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
      bloc.route.push(event);
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
    return Container(
      child: BlocBuilder<NavigationBloc, NavigationState>(
        cubit: bloc,
        builder: (context, state) {
          //printstate);
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
          } else if(state is NavigatedToEditingListing){
            return ListingOperationViewProvider(listing: state.listing,
            );
          }
        },
      ),
    );
  }
}
