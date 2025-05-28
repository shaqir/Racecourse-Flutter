import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository_revenue_cat.dart';
import 'package:racecourse_tracks/data/services/revenue_cat_service.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/data/services/firestoreservice.dart';
import 'package:racecourse_tracks/firebase_options.dart';
import 'package:racecourse_tracks/ui/compare/view_model/compare_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/core/ui/page_container.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/data/repositories/settings_repository.dart';
import 'package:racecourse_tracks/ui/authentication/widgets/sign_up_screen.dart';
import 'package:racecourse_tracks/ui/core/ui/view_model/page_container_view_model.dart';
import 'package:racecourse_tracks/ui/splash/splash_screen.dart';
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
          create: (context) => SettingsRepository()..init(),
        ),
        Provider.value(value: auth),
        Provider.value(value: firestore),
        Provider.value(value: RevenueCatService()),
        Provider<SubscriptionRepository>(create: (context) => SubscriptionRepositoryRevenueCat(context.read())..init(auth.currentUser?.uid)),
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
        home: auth.currentUser == null ? SignUpScreen() : PageContainer(viewModel: PageContainerViewModel(context.read()),),
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
        MaterialPageRoute(builder: (context) => PageContainer(viewModel: PageContainerViewModel(context.read()),)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
