import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/firestoreservice.dart';
import 'package:racecourse_tracks/firebase_options.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/page_container.dart';
import 'package:racecourse_tracks/screens/SplashScreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirestoreService().getUsers();
  await FirestoreService().getWinddata();
  await FirestoreService().getDirectiondata();
  await FirestoreService().getLengthdata();

  runApp(
    MaterialApp(
      theme: ThemeData(
          fontFamily: 'SourceSansVariable',
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryLightBgColor,
          )),
      debugShowCheckedModeBanner: false,
      home: SplashScreenWithDelay(), //const PageContainer(),
    ),
  );
}

class SplashScreenWithDelay extends StatefulWidget {
  @override
  _SplashScreenWithDelayState createState() => _SplashScreenWithDelayState();
}

class _SplashScreenWithDelayState extends State<SplashScreenWithDelay> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PageContainer()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
