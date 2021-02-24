import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';

class NavigationController {
  BuildContext context;
  NavigationController({this.context});

  NavigationController.of(BuildContext context) {
    this.context = context;
  }
  push<T>({T route}) {
    BlocProvider.of<NavigationBloc>(context)
        .push(MaterialProviderRoute<T>(route: route));
  }

  pop() {
    BlocProvider.of<NavigationBloc>(context).pop();
  }
}
