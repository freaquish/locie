import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/store_bloc.dart';
import 'package:locie/components/primary_container.dart';

class CreateOrEditStore extends StatelessWidget {
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
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
