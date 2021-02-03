import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/invoice_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/views/Invoice/invoice_item_billing.dart';
import 'package:locie/views/Invoice/search_invoice_result.dart';
import 'package:locie/views/Invoice/search_invoice_user.dart';
import 'package:locie/views/Invoice/taxes_discount.dart';

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
