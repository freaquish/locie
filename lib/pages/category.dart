import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/category_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/views/category/create.dart';
import 'package:locie/views/category/selection.dart';
import 'package:locie/views/error_widget.dart';

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
          //printstate);
          if (state is LoadingStates) {
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
          } else if (state is RedirectToStoreCreation) {
            BlocProvider.of<NavigationBloc>(context)
                .push(NavigateToCreateStore());
            // navBloc.route.push(NavigateToCreateStore());
            // navBloc
            return Container();
          } else if (state is CommonCategoryError) {
            return ErrorScreen();
          }
        },
      ),
    );
  }
}
