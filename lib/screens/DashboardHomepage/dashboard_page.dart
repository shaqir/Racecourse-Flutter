import 'package:flutter/material.dart';
import 'package:racecourse_tracks/core/appcolors.dart';
import 'package:grouped_checkbox/grouped_checkbox.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  
  @override
  void initState() {
    super.initState();
   }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 40),
              height: 50.0,
              color: Colors.blue,
              child: const Center(
                child: Text(
                  'CaulField',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      color: Colors.orange,
                      child: Column(
                        children: [
                          Container(
                            color: AppColors.selectedDarkBrownColor,
                            height: 45,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Select',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 16,
                                ),
                                Text('Racecourse',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Container(
                              color: Colors.blueGrey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      color: Colors.blue,
                      child: Column(
                        children: [
                          Container(
                            color: AppColors.selectedDarkBrownColor,
                            height: 45,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Select',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 16,
                                ),
                                Text('Racecourse',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                            color: AppColors.selectedDarkBrownColor,
                            height: 45,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Select',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 16,
                                ),
                                Text('Racecourse',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height:
                  300.0, // This container's height exceeds the screen height.
              color: Colors.green,
              child: const Center(
                child: Text(
                  'Finishing Point Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
            Container(
              height:
                  350.0, // This container's height exceeds the screen height.
              color: Colors.brown,
              child: const Center(
                child: Text(
                  'Table Content',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 