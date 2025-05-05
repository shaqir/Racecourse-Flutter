import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/screens/SettingsPage.dart/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity, // Ensures the container fills the screen width
        height: double.infinity, // Ensures the container fills the screen height
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Distance Unit: Metres | Yards (radio buttons or segmented toggle)
            const Text(
              'Distance Unit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Consumer<SettingsProvider>(
              builder: (context, provider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                      value: 'm',
                      groupValue: provider.distanceUnitValue,
                      onChanged: (value) => provider.setSelectedDistanceUnit(DistanceUnit.metres),
                    ),
                    const Text('Metres', style: TextStyle(color: Colors.black),),
                    Radio(
                      value: 'yd',
                      groupValue: provider.distanceUnitValue,
                      onChanged: (value) => provider.setSelectedDistanceUnit(DistanceUnit.yards),
                    ),
                    const Text('Yards', style: TextStyle(color: Colors.black),),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}