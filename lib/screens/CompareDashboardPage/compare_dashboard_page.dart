import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/common/appfonts.dart';
import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/comparedashboardbox.dart';
import 'package:racecourse_tracks/core/utility/dataprovider.dart';
import 'package:racecourse_tracks/screens/CompareDashboardPage/finishing_port.dart';
import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';

class CompareDashboardPage extends StatefulWidget {
  final ItemListProvider provider;
  CompareDashboardPage({super.key, required this.provider});

  @override
  _CompareDashboardPageState createState() => _CompareDashboardPageState();
}

class _CompareDashboardPageState extends State<CompareDashboardPage> {
  Map<int, String> selectedRacecourseMap = {};
  Map<int, String> selectedRacecourseTypeMap = {};
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void onUserSelected(int index, String racecourse, String racecourseType) {
    setState(() {
      selectedRacecourseMap[index] = racecourse;
      selectedRacecourseTypeMap[index] = racecourseType;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DataProvider(
      selectedRacecourse: selectedRacecourseMap.toString(),
      selectedRacecourseType: selectedRacecourseTypeMap.toString(),
      updateValue: (racecourse, racecourseType) =>
          onUserSelected(_currentPage, racecourse, racecourseType),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            AppMenuButtonTitles.compareRacecourses,
            style: AppFonts.title1,
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Center(
              // Keeps the content centered with space at top & bottom
              child: SizedBox(
                height:
                    400, // Set a fixed height based on the max content height
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 3,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, pageIndex) {
                    int boxIndex = pageIndex + 1;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CompareDashboardBox(
                          users: FirestoreService.users,
                          onUserSelected: (racecourse, racecourseType) =>
                              onUserSelected(
                                  boxIndex, racecourse, racecourseType),
                          provider: widget.provider,
                          selectedRacecourse: selectedRacecourseMap[boxIndex] ??
                              "", // Pass stored selection
                          selectedRacecourseType:
                              selectedRacecourseTypeMap[boxIndex] ?? "",
                        ),
                        if (selectedRacecourseMap.containsKey(boxIndex))
                          FinishingPort(
                            users: FirestoreService.users,
                            winddata: FirestoreService.winddata,
                            direction: FirestoreService.direction,
                            isFromHome: false,
                            selectedRacecourse:
                                selectedRacecourseMap[boxIndex] ?? "",
                            selectedRacecourseType:
                                selectedRacecourseTypeMap[boxIndex] ?? "",
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
            // Left navigation button
            Positioned(
              left: 8,
              top: 0,
              bottom: 110,
              child: Center(
                child: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.chevron_left,
                        size: 22, color: Colors.deepPurple),
                  ),
                  onPressed: _currentPage > 0
                      ? () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                ),
              ),
            ),
            // Right navigation button
            Positioned(
              right: 8,
              top: 0,
              bottom: 110,
              child: Center(
                child: IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.chevron_right,
                        size: 22, color: Colors.deepPurple),
                  ),
                  onPressed: _currentPage < 2
                      ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


//==================== OLD =========================

// import 'package:flutter/material.dart';
// import 'package:racecourse_tracks/core/common/appfonts.dart';
// import 'package:racecourse_tracks/core/common/appmenubuttontitles.dart';
// import 'package:racecourse_tracks/core/utility/firestoreservice.dart';
// import 'package:racecourse_tracks/screens/CompareDashboardPage/comparedashboardbox.dart';
// import 'package:racecourse_tracks/core/utility/dataprovider.dart';
// import 'package:racecourse_tracks/screens/CompareDashboardPage/direction_racecourse.dart';
// import 'package:racecourse_tracks/screens/CompareDashboardPage/finishing_port.dart';
// import 'package:racecourse_tracks/screens/SelectionPage/itemlistprovider.dart';

// class CompareDashboardPage extends StatefulWidget {
//   final ItemListProvider provider;
//   CompareDashboardPage({super.key, required this.provider});

//   @override
//   _CompareDashboardPageState createState() => _CompareDashboardPageState();
// }

// class _CompareDashboardPageState extends State<CompareDashboardPage> {
//   Map<int, String> selectedRacecourseMap = {};
//   Map<int, String> selectedRacecourseTypeMap = {};

//   void onUserSelected(int index, String racecourse, String racecourseType) {
//     setState(() {
//       selectedRacecourseMap[index] = racecourse;
//       selectedRacecourseTypeMap[index] = racecourseType;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DataProvider(
//       selectedRacecourse: selectedRacecourseMap.toString(),
//       selectedRacecourseType: selectedRacecourseTypeMap.toString(),
//       updateValue: (racecourse, racecourseType) =>
//           onUserSelected(0, racecourse, racecourseType), // Default to first
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.deepPurple,
//           title: const Text(
//             AppMenuButtonTitles.compareRacecourses,
//             style: AppFonts.title1,
//           ),
//           centerTitle: true,
//         ),
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               CompareDashboardBox(
//                 users: FirestoreService.users,
//                 onUserSelected: (racecourse, racecourseType) =>
//                     onUserSelected(1, racecourse, racecourseType),
//                 provider: widget.provider,
//               ),
//               if (selectedRacecourseMap.containsKey(1))
//                 FinishingPort(
//                   users: FirestoreService.users,
//                   winddata: FirestoreService.winddata,
//                   direction: FirestoreService.direction,
//                   isFromHome: false,
//                   selectedRacecourse: selectedRacecourseMap[1] ?? "",
//                   selectedRacecourseType: selectedRacecourseTypeMap[1] ?? "",
//                 ),
//               CompareDashboardBox(
//                 users: FirestoreService.users,
//                 onUserSelected: (racecourse, racecourseType) =>
//                     onUserSelected(2, racecourse, racecourseType),
//                 provider: widget.provider,
//               ),
//               if (selectedRacecourseMap.containsKey(2))
//                 FinishingPort(
//                   users: FirestoreService.users,
//                   winddata: FirestoreService.winddata,
//                   direction: FirestoreService.direction,
//                   isFromHome: false,
//                   selectedRacecourse: selectedRacecourseMap[2] ?? "",
//                   selectedRacecourseType: selectedRacecourseTypeMap[2] ?? "",
//                 ),
//               CompareDashboardBox(
//                 users: FirestoreService.users,
//                 onUserSelected: (racecourse, racecourseType) =>
//                     onUserSelected(3, racecourse, racecourseType),
//                 provider: widget.provider,
//               ),
//               if (selectedRacecourseMap.containsKey(3))
//                 FinishingPort(
//                   users: FirestoreService.users,
//                   winddata: FirestoreService.winddata,
//                   direction: FirestoreService.direction,
//                   isFromHome: false,
//                   selectedRacecourse: selectedRacecourseMap[3] ?? "",
//                   selectedRacecourseType: selectedRacecourseTypeMap[3] ?? "",
//                 ),
//               Visibility(
//                 visible: false,
//                 child: DirectionRacecourse(
//                   users: FirestoreService.users,
//                   winddata: FirestoreService.winddata,
//                   direction: FirestoreService.direction,
//                   isFromHome: false,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
