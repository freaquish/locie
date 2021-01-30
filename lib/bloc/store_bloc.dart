import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/firestore_query.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/store.dart';

class StoreState {}

// Returns Create Store Page 1
class InitializingCreateOrEditStore extends StoreState {
  final Store store;
  InitializingCreateOrEditStore({this.store});
}

// Shows uploading page
class UploadingStore extends StoreState {}

// Show address page along with previous store datas
class ShowingAddressPage extends StoreState {
  final Store store;
  ShowingAddressPage(this.store);
}

class ShowingMetaDataPage extends StoreState {
  final Store store;
  ShowingMetaDataPage(this.store);
}

class FetchingPreviousExamples extends StoreState {}

class FetchedPreviousExamples extends StoreState {
  final List<PreviousExamples> examples;
  FetchedPreviousExamples(this.examples);
}

class ShowingAddExamplesPage extends StoreState {}

class FetchingStore extends StoreState {}

class StorePageView extends StoreState {
  final Store store;
  StorePageView(this.store);
}

// The store is created and the user will be transfered to MyStore View
class ShowMyStorePage extends StoreState {
  final Store store;
  ShowMyStorePage(this.store);
}

class StoreEvent {}

// This event whill trigger initialising state and starts store creation page
class InitializeCreateOrEditStore extends StoreEvent {
  final Store store;
  InitializeCreateOrEditStore({this.store});
}

class ProceedToAddressPage extends StoreEvent {
  final Store store;
  ProceedToAddressPage(this.store);
}

class ProceedToMetaDataPage extends StoreEvent {
  final Store store;
  ProceedToMetaDataPage(this.store);
}

// The final page will send Store and account in the bloc state
class CreateStore extends StoreEvent {
  final Store store;
  final Account account;
  CreateStore({this.store, this.account});
}

class EditStore extends StoreEvent {
  final Store store;
  EditStore(this.store);
}

class PreviousExamplesEvent extends StoreEvent {}

class FetchPreviousExamples extends PreviousExamplesEvent {
  final Store store;
  FetchPreviousExamples(this.store);
}

class InitiateAddPreviousExample extends PreviousExamplesEvent {}

// Add Previous example to the store using FieldValue
class AddPreviousExample extends PreviousExamplesEvent {
  final PreviousExamples examples;
  AddPreviousExample(this.examples);
}

// Start fetching my store uisng uid in owner
class FetchMyStore extends StoreEvent {
  final String uid;
  FetchMyStore(this.uid);
}

// Fetch Store using sid for someone elses store
class FetchStoreUsingSid extends StoreEvent {
  final String sid;
  FetchStoreUsingSid(this.sid);
}

class CreateStoreBloc extends Bloc<StoreEvent, StoreState> {
  CreateStoreBloc() : super(InitializingCreateOrEditStore());

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    if (event is InitializeCreateOrEditStore) {
      /**
       * [InitiakizeCreateOrEditStore] will handle Store Creation or editing
       * if events store is null then event is triggered for store creation
       * otherwise for editing, everything is same except in case of editing 
       * the `TextEditingControllers` will have provided store values as default which could be changed
       */
      if (event.store != null) {
        yield InitializingCreateOrEditStore(store: event.store);
      } else {
        yield InitializingCreateOrEditStore();
      }
    } else if (event is CreateStore) {
      // CreateStore commands set store data in the database
      yield UploadingStore();
      FireStoreQuery storeQuery = FireStoreQuery();
      Store store = await storeQuery.createStore(event.store, event.account);
      yield ShowMyStorePage(store);
    } else if (event is EditStore) {
      // Fetch store data using shared prefs
      yield UploadingStore();
      FireStoreQuery storeQuery = FireStoreQuery();
      Store store = await storeQuery.editStore(event.store);
      yield ShowMyStorePage(store);
    } else if (event is ProceedToAddressPage) {
      yield ShowingAddressPage(event.store);
    } else if (event is ProceedToMetaDataPage) {
      yield ShowingMetaDataPage(event.store);
    }
  }

  Stream<StoreState> mapAddPreviousExample(PreviousExamplesEvent event) async* {
    if (event is FetchPreviousExamples) {
      yield FetchingPreviousExamples();
     // TODO: Need to do some fetching
    } else if (event is InitiateAddPreviousExample) {
      yield ShowingAddExamplesPage();
    } else if (event is AddPreviousExample) {

    }
  }
}
