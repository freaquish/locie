import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/firestore_auth.dart';
import 'package:locie/helper/firestore_query.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/account.dart';

class AuthenticationState {}

class ShowSplashScreen extends AuthenticationState {}

class InitialState extends AuthenticationState {}

class RedirectingToHome extends AuthenticationState {}

class ShowingPhoneAuthenticationPage extends AuthenticationState {}

class ShowingOtpPage extends AuthenticationState {
  PhoneAuthentication authentication;
  ShowingOtpPage(this.authentication);
}

class AuthenticatingUser extends AuthenticationState {}

class AuthenticationFailed extends AuthenticationState {
  final String msg;
  AuthenticationFailed({this.msg});
}

class AuthenticationSuccess extends AuthenticationState {
  final User user;
  AuthenticationSuccess(this.user);
}

class FetchingCurrentAccount extends AuthenticationState {}

//
// class FetchedCurrentAccount extends AuthenticationState {
//   final Account account;
//   FetchedCurrentAccount(this.account);
// }

class ShowingRegistrationPage extends AuthenticationState {}

class RegisteringAccount extends AuthenticationState {}

// class RegistrationFailed extends AuthenticationState {}

// class RegistrationSuccess extends AuthenticationState {}

class AuthenticationEvent {}

// This will show splash screen but only in the beggining of the bloc
class TriggerSplashScreen extends AuthenticationEvent {}

// class RedirectToHome extends AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {}

// This event will trigger Bloc to show Phone Number input page
class InitiateLogin extends LoginEvent {}

// This event will trigger Bloc to store PhoneAuthentication state for further action
// and proceeds to OTP page, this event will call the verify function
class ProceedToOtpPage extends LoginEvent {
  final String phoneNumber;
  ProceedToOtpPage(this.phoneNumber);
}

// This event will trigger retry with stored phone number
// class RetryPhoneAuthentication extends LoginEvent {
//   PhoneAuthentication authentication;
//   RetryPhoneAuthentication(this.authentication);
// }

// This event will trigger to show input page again
class CancelPhoneAuthentication extends LoginEvent {}

// This event will authenticate the user with the given OTP and store the retturned user
// On Successs will trigger success state and failure iwll trigger failure state
class AuthenticateUser extends LoginEvent {
  PhoneAuthentication authentication;
  final String otp;
  AuthenticateUser(this.authentication, this.otp);
}

// This event will try to fetch user with given uid in accounts collection
// if returned query is empty then trigger register user
class FetchCurrentAccount extends AuthenticationEvent {
  // PhoneAuthentication authentication;
  FetchCurrentAccount();
}

class RegisteringEvents extends AuthenticationEvent {}

// This event will trigger state to show registreation page
class InitiateRegistration extends RegisteringEvents {}

// Register Account and store data in shared_prefs
class RegisterAccount extends RegisteringEvents {
  final Account account;
  RegisterAccount(this.account);
}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  LocalStorage localStorage = LocalStorage();
  AuthenticationBloc() : super(InitialState());
  FireStoreQuery storeQuery = FireStoreQuery();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    await localStorage.init();
    // await storeQuery.securityCheck();
    if (event is TriggerSplashScreen) {
      // Show splash screen untill we check internet connection
      // verify that account exist and then redirect to home
      // otherwise initiate login page
      yield ShowSplashScreen();
      if (localStorage.prefs.containsKey("uid")) {
        yield RedirectingToHome();
      } else {
        this..add(InitiateLogin());
      }
    } else if (event is LoginEvent) {
      // Login Event mapping to another function for handling
      yield* mapPhoneAuthentication(event);
    } else if (event is FetchCurrentAccount) {
      // This handle will fetch current user by uid
      // If no users exist than trigger registration process
      // else redirect to Home
      yield FetchingCurrentAccount();
      var uid = localStorage.prefs.getString("uid");
      var snapshot = await storeQuery.getAccountSnapshot(uid: uid);

      bool exist = storeQuery.accountExist(snapshot);
      print('$snapshot $exist');
      if (exist) {
        Account account = Account.fromJson(snapshot.data());
        localStorage.setAccount(account);
        yield RedirectingToHome();
      } else {
        this..add(InitiateRegistration());
      }
    } else if (event is RegisteringEvents) {
      yield* mapAccountRegistration(event);
    }
  }

  Stream<AuthenticationState> mapPhoneAuthentication(LoginEvent event) async* {
    // Handler will manage from page transition to authentication
    // and later end the process either to fetching current account or Failed
    if (event is InitiateLogin) {
      if (localStorage.prefs.containsKey("uid")) {
        this..add(FetchCurrentAccount());
      } else {
        yield ShowingPhoneAuthenticationPage();
      }
    } else if (event is ProceedToOtpPage) {
      PhoneAuthentication auth =
          PhoneAuthentication(phoneNumber: event.phoneNumber);
      auth.sendOTP();
      yield ShowingOtpPage(auth);
    } else if (event is AuthenticateUser) {
      yield AuthenticatingUser();
      try {
        await event.authentication.verifyOtp(event.otp);
        print('authenticated..');
        // yield InitialState();
        localStorage.prefs.setString("uid", event.authentication.user.uid);
        localStorage.prefs
            .setString("phone_number", event.authentication.phoneNumber);
        this..add(FetchCurrentAccount());
      } catch (e) {
        print(e);
        yield AuthenticationFailed();
      }
    } else if (event is CancelPhoneAuthentication) {
      yield ShowingPhoneAuthenticationPage();
    }
  }

  Stream<AuthenticationState> mapAccountRegistration(
      RegisteringEvents event) async* {
    if (event is InitiateRegistration) {
      if (localStorage.prefs.containsKey("uid") &&
          localStorage.prefs.containsKey("name")) {
        yield RedirectingToHome();
      } else {
        yield ShowingRegistrationPage();
      }
    } else if (event is RegisterAccount) {
      yield RegisteringAccount();
      Account account = await PhoneAuthentication.createAccount(event.account);
      localStorage.setAccount(account);
      yield RedirectingToHome();
    }
  }
}
