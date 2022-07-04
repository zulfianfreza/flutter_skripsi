import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skripsi/cubit/auth_cubit.dart';
import 'package:skripsi/cubit/blood_oxygen_cubit.dart';
import 'package:skripsi/cubit/heart_rate_cubit.dart';
import 'package:skripsi/cubit/page_cubit.dart';
import 'package:skripsi/pages/all_blood_oxygen_page.dart';
import 'package:skripsi/pages/all_heart_rate_page.dart';
import 'package:skripsi/pages/blood_oxygen_information_page.dart';
import 'package:skripsi/pages/blood_page.dart';
import 'package:skripsi/pages/heart_page.dart';
import 'package:skripsi/pages/heart_rate_information_page.dart';
import 'package:skripsi/pages/high_heart_rate_page.dart';
import 'package:skripsi/pages/low_blood_oxygen_page.dart';
import 'package:skripsi/pages/low_heart_rate_page.dart';
import 'package:skripsi/pages/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skripsi/pages/sign_in_page.dart';
import 'package:skripsi/pages/sign_up_page.dart';
import 'package:skripsi/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PageCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => HeartRateCubit(),
        ),
        BlocProvider(
          create: (context) => BloodOxygenCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => SplashPage(),
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
          '/main': (context) => MainPage(),
          '/heart-rate': (context) => HeartPage(),
          '/heart-rate-information': (context) => HeartRateInformationPage(),
          '/all-heart-rate': (context) => AllHeartRatePage(),
          '/high-heart-rate': (context) => HighHeartRatePage(),
          '/low-heart-rate': (context) => LowHeartRatePage(),
          '/blood-oxygen': (context) => BloodPage(),
          '/blood-oxygen-information': (context) =>
              BloodOxygenInformationPage(),
          '/all-blood-oxygen': (context) => AllBloodOxygenPage(),
          '/low-blood-oxygen': (context) => LowBloodOxygenPage(),
        },
      ),
    );
  }
}
