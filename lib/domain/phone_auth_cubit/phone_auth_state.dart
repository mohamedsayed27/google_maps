abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoadingState extends PhoneAuthState {}
class PhoneAuthErrorState extends PhoneAuthState {
  final String error;

  PhoneAuthErrorState(this.error);
}
class PhoneNumberSubmittedState extends PhoneAuthState {}
class OtbVerifiedState extends PhoneAuthState {}
