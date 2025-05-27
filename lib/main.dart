import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/data/services/firestoreservice.dart';
import 'package:racecourse_tracks/data/services/revenue_cat_service.dart';
import 'package:racecourse_tracks/firebase_options.dart';
import 'package:racecourse_tracks/ui/compare/view_model/compare_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/core/ui/homepage_container.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/screens/SettingsPage.dart/settings_provider.dart';
import 'package:racecourse_tracks/screens/SignUpPage/sign_up_page.dart';
import 'package:racecourse_tracks/screens/SplashScreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  await FirestoreService().getUsers();
  await FirestoreService().getWinddata();
  await FirestoreService().getDirectiondata();
  await FirestoreService().getLengthdata();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('showActionButton', true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  RevenueCatService revenueCatService = RevenueCatService();
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  await revenueCatService.initPlatformState(userId);

  runApp(
    MyApp(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.auth,
    required this.firestore,
  });
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RacecourseRepository()
            ..setAllItems(FirestoreService.users.toSet())
            ..resetAll(),
        ),
        ChangeNotifierProvider(
          create: (context) => CompareDashboardViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider()..init(),
        ),
        Provider.value(value: auth),
        Provider.value(value: firestore)
      ],
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: AppFonts.myCutsomeSourceSansFont,
            primarySwatch: Colors.teal,
            brightness: Brightness.light,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              titleTextStyle: AppFonts.title1,
              iconTheme: IconThemeData(color: Colors.white),
            )),
        debugShowCheckedModeBanner: false,
        home: auth.currentUser == null ? SignUpPage() : HomePageContainer(),
      ),
    );
  }
}

class SplashScreenWithDelay extends StatefulWidget {
  const SplashScreenWithDelay({super.key});

  @override
  State<SplashScreenWithDelay> createState() => _SplashScreenWithDelayState();
}

class _SplashScreenWithDelayState extends State<SplashScreenWithDelay> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePageContainer()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
