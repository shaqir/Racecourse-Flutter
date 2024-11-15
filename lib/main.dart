import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/bottom_nav_bar.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const BottomNavBar(),
    ));
