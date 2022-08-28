import 'package:google_maps/domain/phone_auth_cubit/phone_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
   late String verificationId;

  PhoneAuthCubit() : super(PhoneAuthInitial());

 static PhoneAuthCubit get(context) => BlocProvider.of(context);



  Future<void> phoneAuth(String phoneNumber) async {
    emit(PhoneAuthLoadingState());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$phoneNumber',
      timeout: const Duration(seconds: 30),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('verificationCompleted');
     signIn(credential);
  }

  void verificationFailed(FirebaseAuthException error) {
    print(error.toString());
    emit(PhoneAuthErrorState(error.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {

     this.verificationId =  verificationId;
     print(this.verificationId);
    emit(PhoneNumberSubmittedState());
  }

//commenntttt
  Future<void> submitOtp(String otpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpCode);
     signIn(credential);
  }

  Future<void> signIn(AuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(OtbVerifiedState());
    } catch (error) {
      emit(PhoneAuthErrorState(error.toString()));
    }
  }

  Future<void> loggedOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User loggedIn() {
    return FirebaseAuth.instance.currentUser!;
  }
}
