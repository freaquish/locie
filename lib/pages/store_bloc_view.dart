import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/store_view_bloc.dart';
import 'package:locie/components/loading_container/work_container.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/models/listing.dart';
import 'package:locie/singleton.dart';
import 'package:locie/views/Store_view/about_store.dart';
import 'package:locie/views/Store_view/product.dart';
import 'package:locie/views/Store_view/work.dart';

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
            return StoreAboutWidget(singleton.store);
          } else if (state is FetchedStoreWorks) {
            singleton.examples = state.examples;
            return StoreWorksWidget(singleton.examples);
          } else if (state is FetchedStoreProducts) {
            // print(state.listings);
            Listing li = state.listings[0];
            li.id = '23';
            Listing li2 = state.listings[0];
            li.id = '232';
            Listing li3 = state.listings[0];
            li.id = '233';
            state.listings.add(li);
            state.listings.add(li2);
            state.listings.add(li3);
            return StoreProductWidget(state.listings);
          }
        },
      ),
    );
  }
}
