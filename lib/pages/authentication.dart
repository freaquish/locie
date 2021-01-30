import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/bloc/authentication_bloc.dart';
import 'package:locie/components/primary_container.dart';
import 'package:locie/pages/home.dart';
import 'package:locie/views/loadings.dart';
import 'package:locie/views/phone_authentication.dart';
import 'package:locie/views/registration_screen.dart';
import 'package:locie/views/verify_otp.dart';

class AuthenticationWidget extends StatelessWidget {
  final AuthenticationEvent event;
  AuthenticationWidget({Key key, this.event}) : super(key: key);
  final AuthenticationBloc bloc = AuthenticationBloc();

  @override
  Widget build(BuildContext context) {
    // TODO: Change InitialLogin to Splash Screen
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
          } else if (state is RedirectingToHome) {
            return HomeWidget();
          }
          return CircularLoading();
        },
      ),
    );
  }
}
