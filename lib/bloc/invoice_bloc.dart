
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/invoice.dart';
import 'package:locie/repo/invoice_repo.dart';

class InvoiceState{}

class LoadingState extends InvoiceState{}

class ErrorState extends InvoiceState {}

class ShowingPhoneInputPage extends InvoiceState {}

class ShowingCustomerResultPage extends InvoiceState {
  final Account account;
  final String phoneNumber;
  ShowingCustomerResultPage({this.account, this.phoneNumber});
}

class ShowingItemInputPage extends InvoiceState {
  final Invoice invoice;
  ShowingItemInputPage(this.invoice);
}

class ShowingFinanceInputPage extends InvoiceState {
  final Invoice invoice;
  ShowingFinanceInputPage(this.invoice);
}

class CreatingInvoice extends LoadingState {}

class FetchingInvoices extends LoadingState {}

class InvoiceEvent {}

class InvoiceCustomerPhoneInputPageLaunch extends InvoiceEvent{}

class PopBackPages extends InvoiceEvent{}

class SearchCustomerForInvoice extends InvoiceEvent {
  final String phoneNumber;
  SearchCustomerForInvoice(this.phoneNumber);
}

class ItemInputPageLaunch extends InvoiceEvent {
  final Invoice invoice;
  ItemInputPageLaunch(this.invoice);
}

class FinanceInputPageLaunch extends InvoiceEvent {
  final Invoice invoice;
  FinanceInputPageLaunch(this.invoice);
}

class CreateInvoiceOnServer extends InvoiceEvent {
  final Invoice invoice;
  CreateInvoiceOnServer(this.invoice);
}

class FetchMyInvoices extends InvoiceEvent {}

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(LoadingState());
  InvoiceRepo repo = InvoiceRepo();

  InvoiceEvent lastEvent;

  @override
  Stream<InvoiceState> mapEventToState(InvoiceEvent event) async*{
    if(event is InvoiceCustomerPhoneInputPageLaunch){
      lastEvent = event;
      yield ShowingPhoneInputPage();
    }else if(event is SearchCustomerForInvoice) {
      yield LoadingState();
      Account account = await repo.searchAccount(event.phoneNumber);
      yield ShowingCustomerResultPage(account: account, phoneNumber: event.phoneNumber);
    }else if(event is ItemInputPageLaunch){
      yield ShowingItemInputPage(event.invoice);
    }else if(event is FinanceInputPageLaunch){
      lastEvent = event;
      yield ShowingFinanceInputPage(event.invoice);
    }else if(event is CreateInvoiceOnServer) {
      yield CreatingInvoice();
      await repo.createInvoice(event.invoice);
      this..add(FetchMyInvoices());
    }

  }

}

