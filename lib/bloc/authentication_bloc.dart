import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locie/helper/firestore_auth.dart';
import 'package:locie/helper/firestore_query.dart';
import 'package:locie/helper/local_storage.dart';
import 'package:locie/models/account.dart';
import 'package:locie/models/store.dart';

class AuthenticationState {}

class ShowSplashScreen extends AuthenticationState {}

class InitialState extends AuthenticationState {}

class CommonAuthenticationError extends AuthenticationState {}

class AccountRegistrationFailed extends AuthenticationState {}

class AuthenticationCompleted extends AuthenticationState {}

class ShowingPhoneAuthenticationPage extends AuthenticationState {
  final bool error;
  ShowingPhoneAuthenticationPage({this.error = false});
}

class ShowingOtpPage extends AuthenticationState {
  PhoneAuthentication authentication;
  ShowingOtpPage(this.authentication);
}

class AuthenticatingUser extends AuthenticationState {}

class AuthenticationFailed extends CommonAuthenticationError {
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

class PhoneAuthenticationFailed extends LoginEvent {}

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

class SetupStore extends AuthenticationEvent {
  final String accountId;
  SetupStore(this.accountId);
}

class AuthenticationObject {
  FirebaseAuth auth = FirebaseAuth.instance;
  LocalStorage localStorage = LocalStorage();

  Future<User> getCurrentUserFromFirebase() async {
    User user = auth.currentUser;
    return user;
  }

  Future<bool> isUserExistInFirebase() async {
    return (await getCurrentUserFromFirebase()) != null;
  }

  Future<bool> isAccountExist() async {
    await localStorage.init();
    return (await isUserExistInFirebase()) &&
        localStorage.prefs.containsKey("uid") &&
        localStorage.prefs.containsKey("name");
  }
}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  LocalStorage localStorage = LocalStorage();
  AuthenticationBloc() : super(InitialState());
  AuthenticationObject authObject = AuthenticationObject();
  FireStoreQuery storeQuery = FireStoreQuery();
  final fcm = FirebaseMessaging();

  Future<void> processFcmToken(String uid) async {
    String token = await fcm.getToken();
    PhoneAuthentication.updateToken(token, uid);
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    await localStorage.init();

    try {
      if (event is TriggerSplashScreen) {
        // Show splash screen untill we check internet connection
        // verify that account exist and then redirect to home
        // otherwise initiate login page
        yield ShowSplashScreen();
        if (await authObject.isAccountExist()) {
          yield AuthenticationCompleted();
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
        // First check account exist in system if yes then proceed to next step
        // else
        // Check if account exist in db, else launch Registration
        if (await authObject.isAccountExist()) {
          // Account exist in db then update token and move forward
          Account account = await localStorage.getAccount();
          processFcmToken(account.uid);
          this..add(SetupStore(account.uid));
        } else {
          Account account = await storeQuery
              .fetchSystemAccount(localStorage.prefs.getString("uid"));

          if (account == null) {
            // move to Registration page because user is not registered
            this..add(InitiateRegistration());
          } else {
            // Account has been fetched
            await localStorage.setAccount(account);
            processFcmToken(account.uid);
            this..add(SetupStore(account.uid));
          }
        }
      } else if (event is RegisteringEvents) {
        yield* mapAccountRegistration(event);
      } else if (event is SetupStore) {
        Store store = await storeQuery.fetchStore(event.accountId);
        if (store != null) {
          await localStorage.setStore(store);
        }
        yield AuthenticationCompleted();
      }
    } catch (e) {
      yield CommonAuthenticationError();
    }
  }

  void proceedAfterUserVerification(String phoneNumber, String uid) {
    localStorage.prefs.setString("uid", uid);
    localStorage.prefs.setString("phone_number", phoneNumber);
    this..add(FetchCurrentAccount());
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
      auth.sendOTP((uid) {
        proceedAfterUserVerification(auth.phoneNumber, uid);
      });
      yield ShowingOtpPage(auth);
    } else if (event is AuthenticateUser) {
      yield AuthenticatingUser();
      try {
        await event.authentication.verifyOtp(event.otp);
        proceedAfterUserVerification(
            event.authentication.phoneNumber, event.authentication.user.uid);
      } catch (e) {
        this..add(PhoneAuthenticationFailed());
      }
    } else if (event is CancelPhoneAuthentication) {
      yield ShowingPhoneAuthenticationPage();
    } else if (event is PhoneAuthenticationFailed) {
      yield ShowingPhoneAuthenticationPage(error: true);
    }
  }

  Stream<AuthenticationState> mapAccountRegistration(
      RegisteringEvents event) async* {
    // try {
    if (event is InitiateRegistration) {
      if (await authObject.isAccountExist()) {
        yield AuthenticationCompleted();
      } else {
        yield ShowingRegistrationPage();
      }
    } else if (event is RegisterAccount) {
      yield RegisteringAccount();
      Account account = await PhoneAuthentication.createAccount(event.account);
      localStorage.setAccount(account);
      // localStorage.prefs.setBool("account_registered", true);
      yield AuthenticationCompleted();
    }
    // } catch (e) {
    //   yield AccountRegistrationFailed();
    // }
  }
}
