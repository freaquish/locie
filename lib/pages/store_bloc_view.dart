import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/store_view_bloc.dart';
import 'package:locie/components/loading_container/work_container.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/singleton.dart';
import 'package:locie/views/Store_view/about_store.dart';
import 'package:locie/views/Store_view/product.dart';
import 'package:locie/views/Store_view/reviews.dart';
import 'package:locie/views/Store_view/store_view.dart';
import 'package:locie/views/Store_view/store_widget.dart';
import 'package:locie/views/Store_view/work.dart';
import 'package:locie/views/error_widget.dart';

/// Bloc used to populate store view ...

class StoreViewProvider extends StatelessWidget {
  final StoreViewEvent event;
  StoreViewBloc bloc;
  StoreViewGlobalStateSingleton singleton;
  StoreViewProvider(this.event, {this.singleton, this.bloc});
  @override
  Widget build(BuildContext context) {
    if (bloc == null) {
      bloc = StoreViewBloc();
    }
    return Container(
      child: BlocProvider<StoreViewBloc>(
        create: (context) => bloc..add(event),
        child: StoreViewBuilder(
          singleton: singleton,
        ),
      ),
    );
  }
}

class StoreViewBuilder extends StatelessWidget {
  StoreViewGlobalStateSingleton singleton;
  StoreViewBuilder({this.singleton});
  @override
  Widget build(BuildContext context) {
    if (singleton == null) {
      singleton = StoreViewGlobalStateSingleton();
    }
    StoreViewBloc bloc = BlocProvider.of<StoreViewBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<StoreViewBloc, StoreViewState>(
        cubit: bloc,
        builder: (context, state) {
          //printstate);
          if (state is LoadingState) {
            return WorkLoadingContainer();
          } else if (state is FetchedStore) {
            singleton.store = state.store;
            // //print((state.store.rating.toString() + "Store About widget");
            return StoreAboutWidget(
              singleton.store,
              isEditable: state.isStoreMine,
            );
          } else if (state is FetchedStoreWorks) {
            singleton.examples = state.examples;
            return StoreWorksWidget(singleton.examples);
          } else if (state is FetchedStoreProducts) {
            return StoreProductWidget(
              state.listings,
              categories: state.categroies,
              sid: state.sid,
              current: state.current,
            );
          } else if (state is FetchedStoreReviews) {
            return StoreReviewsWidget(state.reviews);
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

class StoreWidgetProvider extends StatelessWidget {
  final StoreViewEvent event;
  final String sid;
  StoreWidgetProvider({this.event, this.sid});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<StoreViewBloc>(
        create: (context) => StoreViewBloc()..add(FetchStore(sid)),
        child: StoreWidgetBuilder(event),
      ),
    );
  }
}

class StoreWidgetBuilder extends StatelessWidget {
  final StoreViewEvent event;
  StoreWidgetBuilder(this.event);
  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      widget: BlocBuilder<StoreViewBloc, StoreViewState>(
        cubit: BlocProvider.of<StoreViewBloc>(context),
        builder: (context, state) {
          if (state is ShowingStoreViewWidget) {
            //print((state.store.rating.toString() + " Showing Store View Widget");
            return StoreViewWidget(
              event: event,
              store: state.store,
              sid: state.store.id,
              isEditable: state.isEditable,
            );
          } else if (state is CommonStoreViewError) {
            return ErrorScreen();
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
