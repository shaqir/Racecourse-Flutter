import 'package:flutter/material.dart';
import 'package:racecourse_tracks/data/repositories/settings_repository.dart';
import 'package:racecourse_tracks/ui/profile/view_model/settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.viewModel});
  final SettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity, // Ensures the container fills the screen width
        height: double.infinity, // Ensures the container fills the screen height
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Distance Unit: Metres | Yards (radio buttons or segmented toggle)
            const Text(
              'Distance Unit',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                return RadioGroup(
                  groupValue: viewModel.distanceUnitValue,
                  onChanged: (value) => viewModel.setSelectedDistanceUnit(value == 'm' ? DistanceUnit.metres : DistanceUnit.yards),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'm',
                      ),
                      const Text('Metres'),
                      Radio(
                        value: 'yd',
                      ),
                      const Text('Yards'),
                    ],
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}