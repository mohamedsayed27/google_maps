import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps/data/models/user_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps/domain/auth/phone_auth_state.dart';
import 'package:image_picker/image_picker.dart';

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
    this.verificationId = verificationId;
    print(this.verificationId);
    emit(PhoneNumberSubmittedState());
  }

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

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getImagePick() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    try {
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        emit(GetPickedImageSuccessState());
      } else {
        return;
      }
    } catch (error) {
      emit(GetPickedImageErrorState(error: error.toString()));
    }
  }

  Future<String> uploadProfileImage() async {
    TaskSnapshot snap = await FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!);
    String image = await snap.ref.getDownloadURL();
    return image;
  }


 //TODO : Complete save phone on storage
  Future<String> uploadPhoneFirebase(String childName )async{
    Reference ref = FirebaseStorage.instance.ref().child('users phones').child(loggedIn().phoneNumber!);
    UploadTask uploadTask = ref.putString(loggedIn().phoneNumber!);
    TaskSnapshot snap = await uploadTask;
    String url = snap.ref.toString();
    return url;
  }

  UserDataModel? userDataModel;


  // signing up with photo
  void signUpWithImage({
    required String name,
  }) async {
    emit(SignUpLoadingState());
    String image = await uploadProfileImage();
    userDataModel = UserDataModel(image: image, name: name);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .set(userDataModel!.toJson()).then((value) {
      print(userDataModel!.image);
      emit(SignUpSuccessState());
    }).catchError((error){
      emit(SignUpErrorState(error.toString()));
    });
    // try{
    //   await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
    //       .set(userDataModel!.toJson());
    //   print(userDataModel!.image);
    //   emit(SignUpSuccessState());
    // }catch(error){
    //   emit(SignUpErrorState(error.toString()));
    // }
  }



  // signing up without photo
  void signUpWithoutImage({
    required String name,
  }) async {
    emit(SignUpLoadingState());
    userDataModel = UserDataModel(image: 'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg', name: name);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
        .set(userDataModel!.toJson()).then((value) {
      print(userDataModel!.image);
      emit(SignUpSuccessState());
    }).catchError((error){
      emit(SignUpErrorState(error.toString()));
    });
    // try{
    //   await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
    //       .set(userDataModel!.toJson());
    //   print(userDataModel!.image);
    //   emit(SignUpSuccessState());
    // }catch(error){
    //   emit(SignUpErrorState(error.toString()));
    // }
  }
}
