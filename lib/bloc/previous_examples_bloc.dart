import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/store.dart';
import 'package:locie/repo/prev_examples_repo.dart';

class PreviousExampleState {}

class LoadingState extends PreviousExampleState {}

class ShowingPreviousExamples extends PreviousExampleState {
  final PreviousExamples examples;
  ShowingPreviousExamples({this.examples});
}

class ShowingMyPreviousExamples extends PreviousExampleState {
  final PreviousExamples examples;
  ShowingMyPreviousExamples({this.examples});
}

class InsertedExample extends PreviousExampleState {}

class ShowingAddNewExamplePage extends PreviousExampleState {}

class InsertingNewExample extends PreviousExampleState {}

class InsertedNewExample extends PreviousExampleState {}

class PreviousExampleEvent {}

class FetchPreviousExamples extends PreviousExampleEvent {
  final String store;
  FetchPreviousExamples({this.store});
}

class InitiateAddNewPreviousExample extends PreviousExampleEvent {}

class AddPreviousExample extends PreviousExampleEvent {
  final PreviousExample example;
  AddPreviousExample(this.example);
}

class PreviousExamplesBloc
    extends Bloc<PreviousExampleEvent, PreviousExampleState> {
  PreviousExamplesBloc() : super(LoadingState());
  PreviousExamplesRepo repo = PreviousExamplesRepo();
  LocalStorage localStorage = LocalStorage();

  @override
  Stream<PreviousExampleState> mapEventToState(
      PreviousExampleEvent event) async* {
    if (event is FetchPreviousExamples) {
      await localStorage.init();
      yield LoadingState();
      PreviousExamples examples = await repo.fetchWorks(id: event.store);
      if (localStorage.prefs.getString("sid") == examples.sid) {
        yield ShowingMyPreviousExamples(examples: examples);
      } else {
        yield ShowingPreviousExamples(examples: examples);
      }
    } else if (event is InitiateAddNewPreviousExample) {
      yield ShowingAddNewExamplePage();
    } else if (event is AddPreviousExample) {
      yield InsertingNewExample();
      await repo.insertWork(event.example);
      yield InsertedExample();
    }
  }
}
