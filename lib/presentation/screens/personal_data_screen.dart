import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/auth/phone_auth_cubit.dart';
import '../../domain/auth/phone_auth_state.dart';

class PersonalDataScreen extends StatelessWidget {
  PersonalDataScreen({Key? key}) : super(key: key);
   TextEditingController nameController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  void showProgressIndicator(BuildContext context) {
    AlertDialog alertDialog = const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (context) => alertDialog,
        barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => PhoneAuthCubit(),
        child: BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
            builder: (context, state) {
              var cubit = PhoneAuthCubit.get(context);
              return Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 65,
                                  backgroundColor: Colors.white,
                                  backgroundImage: cubit.profileImage ==
                                          null
                                      ? const NetworkImage(
                                          'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg')
                                      : Image.file(cubit.profileImage!).image,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                      onPressed: () {
                                        cubit.getImagePick();
                                      },
                                      icon: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.black,
                                      )),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Colors.black,width: 2)
                            ),
                            child: TextFormField(
                              controller: nameController,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Your Name'),
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                if (cubit.profileImage != null) {
                                  cubit.signUpWithImage(
                                      name: nameController.text);
                                } else {
                                  cubit.signUpWithoutImage(
                                      name: nameController.text);
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                )),
                            child: const Text(
                              'Sign up',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            listener: (context, state) {
              if(state is SignUpLoadingState){
                showProgressIndicator(context);
              }
              if(state is SignUpSuccessState){
                Navigator.pop(context);
              }
            }),
      ),
    );
  }
}
