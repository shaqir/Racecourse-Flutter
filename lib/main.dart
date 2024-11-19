import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:racecourse_tracks/core/firestoreservice.dart';
import 'package:racecourse_tracks/firebase_options.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/page_container.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirestoreService().getUsers();
  await FirestoreService().getWinddata();
  await FirestoreService().getDirectiondata();

  runApp(MaterialApp(
          
        theme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
          appBarTheme:  const AppBarTheme(
            backgroundColor: AppColors.primaryLightBgColor,
          )
        ),
        
        debugShowCheckedModeBanner: false,
        home: const PageContainer(),
      ),);
}

