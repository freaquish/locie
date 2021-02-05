import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/search_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/views/search_list_view.dart';

class SearchProvider extends StatelessWidget {
  final SearchEvent event;
  final SearchBloc bloc;
  SearchProvider({this.event, this.bloc});
  @override
  Widget build(BuildContext context) {
    SearchEvent _event = event != null ? event : SearchDefaultStoresForHome();
    return Container(
      child: BlocProvider<SearchBloc>(
        create: (context) => bloc..add(_event),
        child: SearchBuilder(),
      ),
    );
  }
}

class SearchBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      widget: BlocBuilder<SearchBloc, SearchState>(
        cubit: BlocProvider.of<SearchBloc>(context),
        builder: (context, state) {
          print(state);
          if (state is SearchResults) {
            return SearchListView(
              listings: state.listings,
              stores: state.stores,
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
