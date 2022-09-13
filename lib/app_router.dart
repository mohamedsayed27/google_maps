import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps/presentation/screens/login_screen.dart';
import 'package:google_maps/presentation/screens/map_screen.dart';
import 'package:google_maps/presentation/screens/otp_screen.dart';
import 'package:google_maps/presentation/screens/personal_data_screen.dart';
import 'constants/strings.dart';
import 'data/repository/maps_repository.dart';
import 'data/webservices/place_webservices.dart';
import 'domain/auth/phone_auth_cubit.dart';
import 'domain/maps/maps_cubit.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case personalScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: PersonalDataScreen(),
          ),
        );
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: LoginScreen(),
          ),
        );
      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: phoneAuthCubit!,
                  child: OtpScreen(
                    phoneNumber: phoneNumber,
                  ),
                ));
      case mapScreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) =>
                      MapsCubit(MapsRepository(PlacesWebServices())),
                  child: const MapScreen(),
                ));
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('No Screen is defined for this route.'),
            ),
          ),
        );
    }
  }
}
