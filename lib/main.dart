import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/homepage_container.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';
import 'package:racecourse_tracks/screens/SplashScreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // WidgetsFlutterBinding.ensureInitialized();
  // await fetchAndReadExcel();

  await FirestoreService().getUsers();
  await FirestoreService().getWinddata();
  await FirestoreService().getDirectiondata();
  await FirestoreService().getLengthdata();
  SharedPreferences prefs = await SharedPreferences.getInstance();  
  prefs.setBool('showActionButton', true);


  runApp(
    ChangeNotifierProvider(
      create: (context) => ItemListProvider()..setAllItems(FirestoreService.users.toSet())..resetAll(),
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: AppFonts.myCutsomeSourceSansFont,
            primarySwatch: Colors.teal,
            brightness: Brightness.dark,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.deepPurple,
              titleTextStyle: AppFonts.title1,
            )),
        debugShowCheckedModeBanner: false,
        home: HomePageContainer(),
      ),
    ),
  );
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
