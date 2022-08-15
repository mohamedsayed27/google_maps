import 'package:flutter/material.dart';
import 'package:google_maps/constants/colors.dart';
import 'package:google_maps/domain/phone_auth_cubit/phone_auth_cubit.dart';
import 'package:google_maps/domain/phone_auth_cubit/phone_auth_state.dart';
import '../../constants/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  late String phoneNumber;
  final _phoneFormKey = GlobalKey<FormState>();
  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What is your phone number',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: const Text(
            'Please Enter your phone number to verify your account',
            style: TextStyle(fontSize: 17, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFormField() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.lightGrey,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: Text(
              '${generateCountryFlag()} +20',
              style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 2,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.blue,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 18,
                letterSpacing: 2.0,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your phone number';
                } else if (value.length < 11) {
                  return 'Too short phone number';
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgressIndicator(context);
          _register(context);
        },
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(110, 50),
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            )),
        child: const Text(
          'Nest',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context)async{
    if(!_phoneFormKey.currentState!.validate()){
      Navigator.pop(context);
      return;
    }else{
      Navigator.pop(context);
      _phoneFormKey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).phoneAuth(phoneNumber);

    }
  }
  void showProgressIndicator(BuildContext context){
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
      ),
    );
    showDialog(context: context, builder: (context)=>alertDialog,barrierDismissible: false);
  }
  Widget _buildPhoneNumberSubmittedBloc(){
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (previous, current){
        return previous != current;
      },
        listener: (context, state){
          if(state is PhoneAuthLoadingState){
            showProgressIndicator(context);
          }
          if(state is PhoneNumberSubmittedState){
            Navigator.pop(context);
            Navigator.of(context).pushNamed(otpScreen, arguments: phoneNumber);
          }
          if(state is PhoneAuthErrorState){
            // Navigator.pop(context);
            String error = (state).error;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:Text(error),
                backgroundColor: Colors.black,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
      child: Container(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: _phoneFormKey,
            child: Container(
              margin: const EdgeInsets.only(top: 60,left: 32,right: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntroTexts(),
                  const SizedBox(
                    height: 100,
                  ),
                  _buildPhoneFormField(),
                  const SizedBox(
                    height: 50,
                  ),
                  _buildNextButton(context),
                  _buildPhoneNumberSubmittedBloc()
                ],
              ),
            ),
          )),
    );
  }
}
