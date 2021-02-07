import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/authentication_bloc.dart';
import 'package:locie/bloc/navigation_bloc.dart';
import 'package:locie/bloc/navigation_event.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/views/error_widget.dart';
import 'package:locie/views/loadings.dart';
import 'package:locie/views/authentication/phone_authentication.dart';
import 'package:locie/views/authentication/registration_screen.dart';
import 'package:locie/views/authentication/verify_otp.dart';
import 'package:locie/views/splash_screen.dart';

class AuthenticationWidget extends StatelessWidget {
  final AuthenticationEvent event;
  AuthenticationWidget({Key key, this.event}) : super(key: key);
  final AuthenticationBloc bloc = AuthenticationBloc();

  @override
  Widget build(BuildContext context) {
    AuthenticationEvent initialEvent = InitiateLogin();
    return Container(
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => bloc..add(initialEvent),
        child: AuthenticationBuilder(),
      ),
    );
  }
}

class AuthenticationBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc bloc = BlocProvider.of<AuthenticationBloc>(context);
    return PrimaryContainer(
      widget: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        cubit: bloc,
        builder: (BuildContext context, AuthenticationState state) {
          // //(state);
          if (state is InitialState) {
            return CircularLoading();
          } else if (state is ShowingPhoneAuthenticationPage) {
            return PhoneAuthenticationWidget(bloc: bloc);
          } else if (state is ShowingOtpPage) {
            return VerifyOtpScreen(
              bloc: bloc,
              auth: state.authentication,
            );
          } else if (state is ShowingRegistrationPage) {
            return RegistrationScreen(
              bloc: bloc,
            );
          } else if (state is AuthenticationCompleted) {
            NavigationBloc navBloc = BlocProvider.of<NavigationBloc>(context);
            // //(navBloc.route.length);
            if (navBloc.route.length > 1) {
              navBloc.pop();
            } else {
              navBloc.clear();
              navBloc..add(NavigateToHome());
            }
            return Container();
          } else if (state is CommonAuthenticationError) {
            return ErrorScreen();
          } else if (state is ShowSplashScreen) {
            return SplashScreen();
          }
          return CircularLoading();
        },
      ),
    );
  }
}
