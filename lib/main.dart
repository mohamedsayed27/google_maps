import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/app_router.dart';
import 'package:google_maps/constants/strings.dart';
import 'bloc_observer.dart';
import 'firebase_options.dart';

late String initialRoute;

void main() async {


  Bloc.observer = MyBlocObserver();


  WidgetsFlutterBinding.ensureInitialized();

  //---------------------Firebase Initialization---------------------

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if(user==null){
      initialRoute = loginScreen;
    }else{
      initialRoute = mapScreen;
    }
  });

  runApp( MyApp(appRouter: AppRouter(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});
  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}
