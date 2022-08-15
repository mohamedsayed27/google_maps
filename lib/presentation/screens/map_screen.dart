import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/constants/strings.dart';
import 'package:google_maps/domain/phone_auth_cubit/phone_auth_cubit.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PhoneAuthCubit>(
      create: (context) => phoneAuthCubit,
      child: Scaffold(
        body: Center(
          child: Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                 phoneAuthCubit.loggedOut();
                Navigator.of(context).pushReplacementNamed(loginScreen);
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
          ),
        ),
      ),
    );
  }
}
