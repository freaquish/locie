import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/helper/notification.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/invoice.dart';
import 'package:locie/repo/invoice_repo.dart';

class InvoiceState {}

class LoadingState extends InvoiceState {}

class ErrorState extends InvoiceState {}

class ShowingPhoneInputPage extends InvoiceState {}

class ShowingCustomerResultPage extends InvoiceState {
  final Account account;
  final String phoneNumber;
  ShowingCustomerResultPage({this.account, this.phoneNumber});
}

class ShowingTabInvoices extends InvoiceState {
  final List<Invoice> invoices;
  ShowingTabInvoices(this.invoices);
}

class ShowingItemInputPage extends InvoiceState {
  final Invoice invoice;
  ShowingItemInputPage(this.invoice);
}

class ShowingFinanceInputPage extends InvoiceState {
  final Invoice invoice;
  ShowingFinanceInputPage(this.invoice);
}

class ShowingInvoices extends InvoiceState {
  final bool received;
  final List<Invoice> invoices;
  final bool storeExists;
  ShowingInvoices({this.received = false, this.invoices, this.storeExists});
}

class CreatingInvoice extends LoadingState {}

class FetchingInvoices extends LoadingState {}

class InvoiceEvent {}

class InvoiceCustomerPhoneInputPageLaunch extends InvoiceEvent {}

class PopBackPages extends InvoiceEvent {}

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

class RetreieveTabbedInvoices extends InvoiceEvent {
  final bool sent;
  RetreieveTabbedInvoices({this.sent});
}

class FetchMyInvoices extends InvoiceEvent {
  final bool received;
  FetchMyInvoices({this.received = false});
}

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  InvoiceBloc() : super(LoadingState());
  InvoiceRepo repo = InvoiceRepo();
  LocalStorage localStorage = LocalStorage();

  InvoiceEvent lastEvent;
  final notification = SendNotification();

  List<Invoice> sent;
  List<Invoice> recieved;

  @override
  Stream<InvoiceState> mapEventToState(InvoiceEvent event) async* {
    await localStorage.init();
    if (event is InvoiceCustomerPhoneInputPageLaunch) {
      lastEvent = event;
      yield ShowingPhoneInputPage();
    } else if (event is SearchCustomerForInvoice) {
      yield LoadingState();
      Account account = await repo.searchAccount(event.phoneNumber);
      yield ShowingCustomerResultPage(
          account: account, phoneNumber: event.phoneNumber);
    } else if (event is ItemInputPageLaunch) {
      yield ShowingItemInputPage(event.invoice);
    } else if (event is FinanceInputPageLaunch) {
      lastEvent = event;
      yield ShowingFinanceInputPage(event.invoice);
    } else if (event is CreateInvoiceOnServer) {
      yield CreatingInvoice();
      await repo.createInvoice(event.invoice);
      // if even.invoice.recipient != null --> send notification
      if (event.invoice.recipient != null) {
        dynamic token =
            await notification.getToken(userId: event.invoice.recipient);
        notification.sendNotification(
          tokens: token,
          sender: event.invoice.id,
          notificationType: 'Invoice',
          notificationTitle: 'New Invoice',
          message: event.invoice.generatorName +
              " has created an Invoice for you, with Invoice number " +
              event.invoice.id,
        );
      }
      this..add(FetchMyInvoices());
    } else if (event is FetchMyInvoices) {
      yield LoadingState();
      bool isStoreExists = localStorage.prefs.containsKey("sid");
      // bool showRecieved =
      //     (event.received == true || (event.received == null && isStoreExists));
      // List<Invoice> invoices = await repo.fetchInvoices(received: showRecieved);

      yield ShowingInvoices(
          received: event.received, invoices: [], storeExists: isStoreExists);
    } else if (event is RetreieveTabbedInvoices) {
      print(event);
      yield LoadingState();
      bool isStoreExists = localStorage.prefs.containsKey("sid");
      bool isSent = event.sent == null && isStoreExists ? true : event.sent;
      List<Invoice> invoices = [];
      if (isSent) {
        if (sent == null) {
          sent = await repo.fetchInvoices(received: false);
        }
        invoices = sent;
      } else {
        if (recieved == null) {
          recieved = await repo.fetchInvoices(received: false);
        }
        invoices = recieved;
      }
      yield ShowingTabInvoices(invoices);
    }
  }
}

class MyInvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  MyInvoiceBloc() : super(LoadingState());
  InvoiceRepo repo = InvoiceRepo();
  LocalStorage localStorage = LocalStorage();
  List<Invoice> sent;
  List<Invoice> recieved;

  @override
  Stream<InvoiceState> mapEventToState(InvoiceEvent event) async* {
    await localStorage.init();
    print(event);
    if (event is RetreieveTabbedInvoices) {
      print(event);
      yield LoadingState();
      bool isStoreExists = localStorage.prefs.containsKey("sid");
      bool isSent = event.sent == null && isStoreExists ? true : event.sent;
      List<Invoice> invoices = [];
      if (isSent) {
        if (sent == null) {
          sent = await repo.fetchInvoices(received: false);
        }
        invoices = sent;
      } else {
        if (recieved == null) {
          recieved = await repo.fetchInvoices(received: true);
        }
        invoices = recieved;
      }
      yield ShowingTabInvoices(invoices);
    }
  }
}
