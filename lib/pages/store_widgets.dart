import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/bloc/store_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/models/store.dart';
import 'package:locie/pages/store_bloc_view.dart';
import 'package:locie/views/create_store/address.dart';
import 'package:locie/views/create_store/avatar_name.dart';
import 'package:locie/views/create_store/meta_data.dart';
import 'package:locie/views/error_widget.dart';

class CreateOrEditStoreWidget extends StatelessWidget {
  final Store store;
  CreateOrEditStoreWidget({this.store});
  // final CreateOrEditStoreBloc bloc = CreateOrEditStoreBloc();

  @override
  Widget build(BuildContext context) {
    print(store.toString() + "coesw");
    StoreEvent initialEvent =
        store == null ? InitializeCreateStore() : InitializeEditStore(store);
    return Container(
      child: BlocProvider<CreateOrEditStoreBloc>(
        create: (context) => CreateOrEditStoreBloc()..add(initialEvent),
        child: CreateOrEditStoreBuilder(),
      ),
    );
  }
}

class CreateOrEditStoreBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CreateOrEditStoreBloc bloc =
        BlocProvider.of<CreateOrEditStoreBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<CreateOrEditStoreBloc, StoreState>(
        cubit: bloc,
        builder: (context, state) {
          print(state);
          if (state is InitializingCreateOrEditStore) {
            return CreateStoreWidget(
              bloc: bloc,
            );
          } else if (state is ShowingAddressPage) {
            return AddressWidget(bloc: bloc, store: state.store);
          } else if (state is ShowingMetaDataPage) {
            return MetaDataWidget(
              bloc: bloc,
              store: state.store,
            );
          } else if (state is RedirectToHomeFromCreateStore) {
            BlocProvider.of<NavigationBloc>(context).replace(NavigateToHome());
            return Container();
          } else if (state is InitializedEditPage) {
            print(state.store.toString() + "coesb");
            return CreateStoreWidget(
              bloc: bloc,
              store: state.store,
            );
          } else if (state is ShowMyStorePage) {
            var navBloc = BlocProvider.of<NavigationBloc>(context);
            if (state.afterEdit) {
              navBloc.pop();
            } else {
              navBloc.replace(MaterialProviderRoute<StoreWidgetProvider>(
                  route: StoreWidgetProvider(sid: state.store.id)));
            }
            return Container();
          } else if (state is CommonStoreCreationError) {
            return ErrorScreen();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
