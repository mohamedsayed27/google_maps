abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoadingState extends PhoneAuthState {}
class PhoneAuthErrorState extends PhoneAuthState {
  final String error;

  PhoneAuthErrorState(this.error);
}
class PhoneNumberSubmittedState extends PhoneAuthState {}
class OtbVerifiedState extends PhoneAuthState {}

class GetPickedImageSuccessState extends PhoneAuthState {}
class GetPickedImageErrorState extends PhoneAuthState {
  final String error;
  GetPickedImageErrorState({required this.error});
}

class SignUpLoadingState extends PhoneAuthState {}
class SignUpSuccessState extends PhoneAuthState {}
class SignUpErrorState extends PhoneAuthState {
  final String error;
  SignUpErrorState(this.error);
}


