import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/firestore_query.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/store.dart';

class StoreState {}

// Returns Create Store Page 1
class IntializingCreateStore extends StoreState {}

// Shows uploading page
class CreatingStore extends StoreState {}

// The store is created and the user will be transfered to MyStore View
class CreatedStore extends StoreState {
  final Store store;
  CreatedStore(this.store);
}

class StoreEvent {}

// This event whill trigger initialising state and starts store creation page
class InitializeCreateStore extends StoreEvent {}

// The final page will send Store and account in the bloc state
class CreateStore extends StoreEvent {
  final Store store;
  final Account account;
  CreateStore({this.store, this.account});
}

// Start fetching my store uisng uid in owner
class FetchMyStore extends StoreEvent {
  final String uid;
  FetchMyStore(this.uid);
}

class CreateStoreBloc extends Bloc<StoreEvent, StoreState> {
  CreateStoreBloc() : super(IntializingCreateStore());

  @override
  Stream<StoreState> mapEventToState(StoreEvent event) async* {
    if (event is InitializeCreateStore) {
      yield IntializingCreateStore();
    } else if (event is CreateStore) {
      yield CreatingStore();
      FireStoreQuery storeQuery = FireStoreQuery();
      Store store = await storeQuery.createStore(event.store, event.account);
      yield CreatedStore(store);
    }
  }
}
