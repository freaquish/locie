import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/quotations.dart';
import 'package:locie/repo/listing_repo.dart';

class QuotationState {}

class LoadingQuotationState extends QuotationState {}

class FetchedSentQuotations extends QuotationState {
  final List<Quotation> quotations;
  final bool isStore;
  FetchedSentQuotations({this.quotations = const [], this.isStore = false});
}

class CommonQuotationError extends QuotationState {}

class FetchedReceivedQuotations extends QuotationState {
  final List<Quotation> quotations;
  final bool isStore;
  FetchedReceivedQuotations({this.quotations = const [], this.isStore = false});
}

class QuotationEvent {}

class FetchSentQuotations extends QuotationEvent {}

class FetchReceivedQuotations extends QuotationEvent {}

class QuotationBloc extends Bloc<QuotationEvent, QuotationState> {
  QuotationBloc() : super(LoadingQuotationState());
  LocalStorage localStorage = LocalStorage();
  ListingQuery query = ListingQuery();

  @override
  Stream<QuotationState> mapEventToState(QuotationEvent event) async* {
    try {
      await localStorage.init();
      bool isStoreExist = localStorage.prefs.containsKey("sid");
      print(event);
      if (event is FetchSentQuotations) {
        yield LoadingQuotationState();
        List<Quotation> quotations = await query.fetchQuotations(sent: true);
        yield FetchedSentQuotations(
            quotations: quotations, isStore: isStoreExist);
      } else if (event is FetchReceivedQuotations) {
        yield LoadingQuotationState();
        List<Quotation> quotations = await query.fetchQuotations(sent: false);
        yield FetchedReceivedQuotations(
            quotations: quotations, isStore: isStoreExist);
      }
    } catch (e) {
      yield CommonQuotationError();
    }
  }
}
