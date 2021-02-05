import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/quotation_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/views/quotation/quotation_view.dart';

class QuotationViewProvider extends StatelessWidget {
  final QuotationEvent event;
  QuotationViewProvider(this.event);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider<QuotationBloc>(
        create: (context) => QuotationBloc()..add(event),
        child: QuotationBuilder(),
      ),
    );
  }
}

class QuotationBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuotationBloc bloc = BlocProvider.of<QuotationBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<QuotationBloc, QuotationState>(
        cubit: bloc,
        builder: (context, state) {
          print(state);
          if (state is FetchedSentQuotations) {
            print(state.quotations[0].toJson());
            return ListView.builder(
              itemCount: state.quotations.length,
              itemBuilder: (context, index) => QuotationCard(
                state.quotations[index],
                isSent: true,
              ),
            );
          } else if (state is FetchedReceivedQuotations) {
            return ListView.builder(
              itemCount: state.quotations.length,
              itemBuilder: (context, index) => QuotationCard(
                state.quotations[index],
                isSent: false,
              ),
            );
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
