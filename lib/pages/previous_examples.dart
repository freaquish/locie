import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/previous_examples_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/get_it.dart';
import 'package:locie/views/Example/previous_example.dart';
import 'package:locie/views/error_widget.dart';

class PreviousExampleProvider extends StatelessWidget {
  final String sid;
  final PreviousExampleEvent event;
  PreviousExampleProvider({this.sid, this.event});

  @override
  Widget build(BuildContext context) {
    PreviousExampleEvent initialEvent =
        event != null ? event : FetchPreviousExamples(store: sid);
    //printevent);
    return Container(
      child: BlocProvider<PreviousExamplesBloc>(
        create: (context) => PreviousExamplesBloc()..add(initialEvent),
        child: PreviousExampleBuilder(),
      ),
    );
  }
}

class PreviousExampleBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PreviousExamplesBloc bloc = BlocProvider.of<PreviousExamplesBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<PreviousExamplesBloc, PreviousExampleState>(
        cubit: bloc,
        builder: (context, state) {
          if (state is LoadingState || state is InsertingNewExample) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is ShowingAddNewExamplePage) {
            return PreviousExampleWidget(bloc: bloc);
          } else if (state is InsertedExample) {
            NavigationController.of(context).pop();
            return Container();
          } else if (state is CommonWorkError) {
            return ErrorScreen();
          }
        },
      ),
    );
  }
}
