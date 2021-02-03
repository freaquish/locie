import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/firestore_query.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/store.dart';

class StoreState {}

// Returns Create Store Page 1
class InitializingCreateOrEditStore extends StoreState {
  final Store store;
  InitializingCreateOrEditStore({this.store});
}

class RedirectToHomeFromCreateStore extends StoreState {}

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
  final PreviousExamples examples;
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
  // final Account account;
  CreateStore({this.store});
}

class EditStore extends StoreEvent {
  final Store store;
  EditStore(this.store);
}

class PreviousExamplesEvent extends StoreEvent {}

class FetchPreviousExamples extends PreviousExamplesEvent {
  // final Store store;
  FetchPreviousExamples();
}

class InitiateAddPreviousExample extends PreviousExamplesEvent {}

// Add Previous example to the store using FieldValue
class AddPreviousExample extends PreviousExamplesEvent {
  final PreviousExample example;
  AddPreviousExample(this.example);
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

class CreateOrEditStoreBloc extends Bloc<StoreEvent, StoreState> {
  CreateOrEditStoreBloc() : super(InitializingCreateOrEditStore());

  FireStoreQuery storeQuery = FireStoreQuery();
  LocalStorage localStorage = LocalStorage();

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    await localStorage.init();
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
        Store store;
        if (localStorage.prefs.containsKey("uid")) {
          var uid = localStorage.prefs.getString("uid");
          store = await storeQuery.fetchStore(uid);
        }
        if (store != null) {
          localStorage.setStore(store);
          yield RedirectToHomeFromCreateStore();
        } else {
          yield InitializingCreateOrEditStore();
        }
      }
    } else if (event is CreateStore) {
      // CreateStore commands set store data in the database
      yield UploadingStore();
      // FireStoreQuery storeQuery = FireStoreQuery();
      var account = await localStorage.getAccount();
      Store store = await storeQuery.createStore(event.store, account);
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
    } else if (event is PreviousExamplesEvent) {
      yield* mapAddPreviousExample(event);
    }
  }

  PreviousExamples examples;
  Stream<StoreState> mapAddPreviousExample(PreviousExamplesEvent event) async* {
    if (event is FetchPreviousExamples) {
      yield FetchingPreviousExamples();
      if (!localStorage.prefs.containsKey("sid")) {
        this..add(InitializeCreateOrEditStore());
      }
      var sid = localStorage.prefs.getString("sid");

      examples = await storeQuery.getExamples(sid);
      yield FetchedPreviousExamples(examples);
    } else if (event is InitiateAddPreviousExample) {
      yield ShowingAddExamplesPage();
    } else if (event is AddPreviousExample) {
      var sid = localStorage.prefs.getString("sid");
      var example =
          await storeQuery.insertExamples(sid: sid, example: event.example);
      if (examples == null) {
        examples = await storeQuery.getExamples(sid);
      } else {
        examples.examples.add(example);
      }

      yield FetchedPreviousExamples(examples);
    }
  }
}
