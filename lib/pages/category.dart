import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/category_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/views/category/create.dart';
import 'package:locie/views/category/selection.dart';

class CategoryProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<CategoryBloc>(
        create: (context) => CategoryBloc()..add(InitiateCategorySelection()),
        child: CategoryBuilder(),
      ),
    );
  }
}

class CategoryBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoryBloc bloc = BlocProvider.of<CategoryBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<CategoryBloc, CategoryState>(
        cubit: bloc,
        builder: (context, state) {
          if (state is InitialState || state is FetchingCategory) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ShowingCategorySelectionPage) {
            return CategorySelection(bloc: bloc, categories: state.category);
          } else if (state is ShowingAddNewCategoryPage) {
            return CreateNewCategoryWidget(
              bloc: bloc,
              current: state.current,
            );
          }
        },
      ),
    );
  }
}
