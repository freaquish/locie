import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/store_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/views/Create_Store/address.dart';
import 'package:locie/views/Create_Store/avatar_name.dart';
import 'package:locie/views/Create_Store/meta_data.dart';

class CreateOrEditStoreWidget extends StatelessWidget {
  final CreateOrEditStoreBloc bloc = CreateOrEditStoreBloc();

  @override
  Widget build(BuildContext context) {
    StoreEvent initialEvent = InitializeCreateOrEditStore();
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
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
