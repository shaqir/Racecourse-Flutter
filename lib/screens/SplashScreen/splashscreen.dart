import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appcolors.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appimages.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.splashBgColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                AppMenuButtonTitles.splashscreenName,
                style: AppFonts.splashNameStyle,
              ),
              const SizedBox(height: 40),  
              Image.asset(
                AppImages.splashLogoImage,  
                width: 150,  
                color: Colors.white, 
              ),
            ],
          )),
    );
  }
}
