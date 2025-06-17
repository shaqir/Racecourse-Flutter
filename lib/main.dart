import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/data/length/length_repository.dart';
import 'package:racecourse_tracks/data/length/length_repository_firestore.dart';
import 'package:racecourse_tracks/data/repositories/direction/direction_repository.dart';
import 'package:racecourse_tracks/data/repositories/direction/direction_repository_firestore.dart';
import 'package:racecourse_tracks/data/repositories/user/user_repository.dart';
import 'package:racecourse_tracks/data/repositories/user/user_repository_firebase.dart';
import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:racecourse_tracks/data/repositories/user_subscription/user_subscription_repository_revenue_cat.dart';
import 'package:racecourse_tracks/data/repositories/wind_data/wind_data_repository.dart';
import 'package:racecourse_tracks/data/repositories/wind_data/wind_data_repository_firestore.dart';
import 'package:racecourse_tracks/data/services/authentication_service.dart';
import 'package:racecourse_tracks/data/services/cloud_functions_service.dart';
import 'package:racecourse_tracks/data/services/revenue_cat_service.dart';
import 'package:racecourse_tracks/ui/authentication/view_model/sign_up_view_model.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';
import 'package:racecourse_tracks/firebase_options.dart';
import 'package:racecourse_tracks/ui/compare/view_model/compare_dashboard_view_model.dart';
import 'package:racecourse_tracks/ui/core/ui/page_container.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/data/repositories/settings_repository.dart';
import 'package:racecourse_tracks/ui/authentication/widgets/sign_up_screen.dart';
import 'package:racecourse_tracks/ui/subscription/view_model/user_subscription_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('showActionButton', true);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: FirebaseAuth.instance),
        Provider.value(value: FirebaseFirestore.instance),
        Provider.value(value: FirebaseFunctions.instance),
        Provider.value(value: RevenueCatService()),
        Provider(create: (context) => FirestoreService(context.read()),),
        Provider(create: (context) => AuthenticationService(context.read())),
        Provider.value(value: FirebaseFunctions.instance),
        Provider(create: (context) => CloudFunctionsService(context.read())),
        ChangeNotifierProvider(
          create: (context) => RacecourseRepository(cloudFunctionsService: context.read(), firestoreService: context.read()),
        ),
        Provider(create: (context) => LengthRepositoryFirestore(context.read()) as LengthRepository),
        Provider(create: (context) => DirectionRepositoryFirestore(context.read()) as DirectionRepository),
        Provider(create: (context) => WindDataRepositoryFirestore(context.read()) as WindDataRepository),
        ChangeNotifierProvider(
          create: (context) => CompareDashboardViewModel(context.read(), context.read(), context.read(), context.read(),)
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsRepository()..init(),
        ),
        
        Provider(
            create: (context) => UserSubscriptionRepositoryRevenueCat(
                context.read(), context.read()) as UserSubscriptionRepository),
        Provider(
            create: (context) =>
                UserRepositoryFirebase(context.read(), context.read())
                    as UserRepository),
        ChangeNotifierProvider(
          create: (context) => UserSubscriptionViewModel(userSubscriptionRepository: context.read())),
      ],
      child: MyApp(
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: context.read<UserRepository>().authUser == null ? SignUpScreen(viewModel: SignUpViewModel(context.read()),) : PageContainer(),
    );
  }
}
