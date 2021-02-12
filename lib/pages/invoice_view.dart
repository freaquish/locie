import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/invoice_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/views/Invoice/invoice_item_billing.dart';
import 'package:locie/views/Invoice/my_invoices.dart';
import 'package:locie/views/Invoice/search_invoice_result.dart';
import 'package:locie/views/Invoice/search_invoice_user.dart';
import 'package:locie/views/Invoice/taxes_discount.dart';
import 'package:locie/views/error_widget.dart';

class InvoiceProvider extends StatelessWidget {
  final InvoiceEvent event;
  InvoiceProvider({this.event});
  @override
  Widget build(BuildContext context) {
    InvoiceEvent initialEvent =
        event == null ? InvoiceCustomerPhoneInputPageLaunch() : event;
    return Container(
      child: BlocProvider<InvoiceBloc>(
        create: (context) => InvoiceBloc()..add(initialEvent),
        child: InvoiceBuilder(),
      ),
    );
  }
}

class InvoiceBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      widget: BlocBuilder<InvoiceBloc, InvoiceState>(
        cubit: BlocProvider.of<InvoiceBloc>(context),
        builder: (context, state) {
          //(state);
          if (state is ShowingPhoneInputPage) {
            return SearchInvoiceUser();
          } else if (state is ShowingCustomerResultPage) {
            return SearchInVoiceResult(
              phoneNumber: state.phoneNumber,
              account: state.account,
            );
          } else if (state is ShowingItemInputPage) {
            return InvoiceItemBilling(state.invoice);
          } else if (state is ShowingFinanceInputPage) {
            return TaxesAndDiscountWidget(invoice: state.invoice);
          } else if (state is ShowingInvoices) {
            return MyInvoices(state.invoices,
                received: state.received, storeExists: state.storeExists);
          } else if (state is CommonInvoiceError) {
            return ErrorScreen();
          }
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class MyInvoiceProvider extends StatelessWidget {
  final MyInvoiceBloc bloc;
  final InvoiceEvent event;
  MyInvoiceProvider({this.bloc, this.event});
  @override
  Widget build(BuildContext context) {
    // //(event);
    return Container(
      child: BlocProvider<MyInvoiceBloc>(
        create: (context) => bloc,
        child: MyInvoiceBuilder(
          bloc: bloc,
        ),
      ),
    );
  }
}

class MyInvoiceBuilder extends StatelessWidget {
  final MyInvoiceBloc bloc;
  MyInvoiceBuilder({this.bloc});
  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
        widget: BlocBuilder<MyInvoiceBloc, InvoiceState>(
      cubit: bloc,
      builder: (context, state) {
        //(state.toString() + "bu");
        if (state is ShowingTabInvoices) {
          return MyInvoicesListWidget(
            state.invoices,
            sent: state.sent,
          );
        } else if (state is CommonInvoiceError) {
          return ErrorScreen();
        }
        return Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        );
      },
    ));
  }
}
