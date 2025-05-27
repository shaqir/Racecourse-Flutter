import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/utils/ad_helper.dart';
import 'package:racecourse_tracks/data/services/firestoreservice.dart';
import 'package:racecourse_tracks/ui/compare/widgets/compare_dashboard_box.dart';
import 'package:racecourse_tracks/ui/core/ui/finishing_port.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';
import 'package:racecourse_tracks/widgets/user_subscription_widget.dart';

class FreeDashboardScreen extends StatefulWidget {
  const FreeDashboardScreen({
    super.key,
  });

  @override
  State<FreeDashboardScreen> createState() => _FreeDashboardScreenState();
}

class _FreeDashboardScreenState extends State<FreeDashboardScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
            });
          }
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    final itemListProvider = Provider.of<RacecourseRepository>(context);
    return Scaffold(
      appBar: AppBar(
        leading: UserSubscriptionWidget(userSubscription: 'Free'),
        centerTitle: true, // Centers the text in the AppBar
        title: Text(
          'Racecourses.Tracks',
          style: AppFonts.title1,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () =>
                  Provider.of<RacecourseRepository>(context, listen: false)
                      .refreshData()),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width:
              double.infinity, // Ensures the container fills the screen width
          height:
              double.infinity, // Ensures the container fills the screen height
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CompareDashboardBox(
                        onRacecourseSelected: (racecourse, racecourseType) =>
                            Provider.of<RacecourseRepository>(context,
                                    listen: false)
                                .setSelectedRacecource(
                                    racecourse, racecourseType),
                        currentRaceCourseChoice:
                            itemListProvider.selectedRacecourse['Racecourse'] ??
                                '',
                        currentRaceCourseTypeChoice: itemListProvider
                                .selectedRacecourse['Racecourse Type'] ??
                            '',
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: AppColors.tablecontentBgColor
                              .withValues(alpha: 0.7), // Background color
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            width: 1,
                            color: Colors.brown,
                          ),
                        ),
                        child: SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: Center(
                              child: itemListProvider
                                      .selectedRacecourse.isNotEmpty
                                  ? Text(
                                      itemListProvider
                                              .selectedRacecourse['Name'] ??
                                          itemListProvider
                                              .selectedRacecourse['Racecourse'],
                                      textAlign: TextAlign.center,
                                      style: AppFonts.titleRaceCourse,
                                    )
                                  : Text(
                                      "No Data Available", // Fallback text when no valid selection
                                      textAlign: TextAlign.center,
                                      style: AppFonts.titleRaceCourse,
                                    ),
                            )),
                      ),
                      FinishingPort(
                        winddata: FirestoreService.winddata,
                        direction: FirestoreService.direction,
                        isFromHome: true,
                        hideWindColumn: true,
                        selectedRacecourseData:
                            itemListProvider.selectedRacecourse,
                        showUpgradeButton: true,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // AdMob Banner
                      if (_bannerAd != null)
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Loader overlay

              if (itemListProvider.isLoading)
                Positioned.fill(
                  child: Container(
                    width: double.infinity, // Full width
                    height: double.infinity, // Full height
                    color: Colors.black
                        .withValues(alpha: 0.75), // Semi-transparent overlay
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 8), // Space between loader and text
                          Text(
                            'Refreshing...',
                            style: AppFonts.body6,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }


}
