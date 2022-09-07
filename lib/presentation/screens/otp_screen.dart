import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/constants/colors.dart';
import 'package:google_maps/constants/strings.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

import '../../domain/auth/phone_auth_cubit.dart';
import '../../domain/auth/phone_auth_state.dart';


// ignore: must_be_immutable
class OtpScreen extends StatelessWidget {
   OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);

   final dynamic phoneNumber ;
   late String otpCode;

   // void _login(BuildContext context){
   //   BlocProvider.of<PhoneAuthCubit>(context).submitOtp(otpCode);
   // }
  Widget _buildIntroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Verify your phone number',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text: TextSpan(
                text: 'Enter your 6 digit number sent to you at ',
                style: const TextStyle(height: 2, fontSize: 17, color: Colors.grey),
                children: <TextSpan>[
                  TextSpan(
                    text: phoneNumber,
                    style: const TextStyle(fontSize: 17,color: AppColors.blue)
                  )
                ]),
          ),
        ),
      ],
    );
  }

  Widget _buildPinField(BuildContext context){
    return PinCodeTextField(
        appContext: context,
        length: 6,
        autoFocus: true,
        cursorColor: Colors.black,
        obscureText: false,
        keyboardType: TextInputType.phone,
        animationType: AnimationType.scale,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(6),
          fieldHeight: 40,
          fieldWidth: 30,
          borderWidth: 1,
          activeColor: AppColors.blue,
          activeFillColor: AppColors.lightBlue,
          inactiveColor: AppColors.blue,
          inactiveFillColor: Colors.white,
          selectedColor: AppColors.blue,
          selectedFillColor: Colors.white
        ),
        animationDuration: const Duration(milliseconds: 300),
        backgroundColor: Colors.white,
        enableActiveFill: true,
        onCompleted: (code){
          otpCode = code;
        },
        onChanged: (value){
          print(value);
        });
  }

  // Widget _buildVerifyButton(BuildContext context){
  //   return Align(
  //     alignment: Alignment.centerRight,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         showProgressIndicator(context);
  //         _login(context);
  //       },
  //       style: ElevatedButton.styleFrom(
  //           minimumSize: const Size(110, 50),
  //           backgroundColor: Colors.black,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(6),
  //           )),
  //       child: const Text(
  //         'Verify',
  //         style: TextStyle(color: Colors.white, fontSize: 16),
  //       ),
  //     ),
  //   );
  // }

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

  // Widget _buildVerificationBloc(){
  //   return BlocListener<PhoneAuthCubit, PhoneAuthState>(
  //     listenWhen: (previous, current){
  //       return previous != current;
  //     },
  //     listener: (context, state){
  //       if(state is PhoneAuthLoadingState){
  //         showProgressIndicator(context);
  //       }
  //       if(state is OtbVerifiedState){
  //         Navigator.pop(context);
  //         Navigator.of(context).pushReplacementNamed(mapScreen);
  //       }
  //       if(state is PhoneAuthErrorState){
  //         String error = (state).error;
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content:Text(error),
  //             backgroundColor: Colors.black,
  //             duration: const Duration(seconds: 3),
  //           ),
  //         );
  //       }
  //     },
  //     child: Container(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
          builder: (context, state){
            var cubit = PhoneAuthCubit.get(context);
            return Scaffold(
                backgroundColor: Colors.white,
                body: Container(
                  margin: const EdgeInsets.only(top: 60,left: 32,right: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroTexts(),
                      const SizedBox(
                        height: 60,
                      ),
                      _buildPinField(context),
                      const SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            showProgressIndicator(context);
                            cubit.submitOtp(otpCode);
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(110, 50),
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              )),
                          child: const Text(
                            'Verify',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ));
          },
          listenWhen: (previous, current){
            return previous != current;
          },
          listener: (context, state){
            if(state is PhoneAuthLoadingState){
              showProgressIndicator(context);
            }
            if(state is OtbVerifiedState){
              // Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(mapScreen);
            }
            if(state is PhoneAuthErrorState){
              String error = (state).error;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:Text(error),
                  backgroundColor: Colors.black,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          }),
    );
  }
}
