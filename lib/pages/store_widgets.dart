import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/bloc/store_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/models/store.dart';
import 'package:locie/views/create_store/address.dart';
import 'package:locie/views/create_store/avatar_name.dart';
import 'package:locie/views/create_store/meta_data.dart';

class CreateOrEditStoreWidget extends StatelessWidget {
  final Store store;
  CreateOrEditStoreWidget({this.store});
  final CreateOrEditStoreBloc bloc = CreateOrEditStoreBloc();

  @override
  Widget build(BuildContext context) {
    print(store.toString() + "coesw");
    StoreEvent initialEvent = InitializeCreateOrEditStore(store: store);
    return Container(
      child: BlocProvider<CreateOrEditStoreBloc>(
        create: (context) => bloc..add(initialEvent),
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
          if (state is InitializingCreateOrEditStore) {
            print(state.store.toString() + "coesb");
            return CreateStoreWidget(
              bloc: bloc,
              store: state.store,
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
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
