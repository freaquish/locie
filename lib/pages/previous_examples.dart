import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/previous_examples_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/views/Example/previous_example.dart';

class PreviousExampleProvider extends StatelessWidget {
  final String sid;
  final PreviousExampleEvent event;
  PreviousExampleProvider({this.sid, this.event});

  @override
  Widget build(BuildContext context) {
    PreviousExampleEvent initialEvent =
        event != null ? event : FetchPreviousExamples(store: sid);
    print(event);
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
          } else if (state is ShowingMyPreviousExamples) {
            //TODO: Show myexamples if state.examples.sid =
          } else if (state is ShowingPreviousExamples) {}
        },
      ),
    );
  }
}
