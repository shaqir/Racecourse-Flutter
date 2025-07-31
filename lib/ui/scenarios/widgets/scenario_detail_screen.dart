import 'package:flutter/material.dart';
import 'package:racecourse_tracks/domain/models/scenario.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/ui/scenarios/view_model/scenarios_view_model.dart';

class ScenarioDetailScreen extends StatelessWidget {
  final Scenario scenario;
  final ScenariosViewModel viewModel;

  const ScenarioDetailScreen({
    super.key,
    required this.scenario,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          scenario.title,
          style: AppFonts.title1,
        ),
        backgroundColor: AppColors.checkboxlist2Color,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section with icon and type
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.checkboxlist2Color,
                    AppColors.checkboxlist2Color.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        scenario.icon,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    scenario.type.displayName,
                    style: AppFonts.title.copyWith(fontSize: 28),
                  ),
                ],
              ),
            ),

            // Content sections
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description section
                  _buildSection(
                    'Overview',
                    scenario.description,
                    Icons.info_outline,
                  ),

                  const SizedBox(height: 24),

                  // Key factors section
                  _buildListSection(
                    'Key Factors',
                    scenario.keyFactors,
                    Icons.key,
                    AppColors.checkboxlist1Color,
                  ),

                  const SizedBox(height: 24),

                  // Ideal conditions section
                  _buildListSection(
                    'Ideal Conditions',
                    scenario.idealConditions,
                    Icons.check_circle_outline,
                    AppColors.checkboxlist3Color,
                  ),

                  const SizedBox(height: 24),

                  // Example tracks section
                  _buildListSection(
                    'Example Tracks',
                    scenario.exampleTracks,
                    Icons.location_on_outlined,
                    AppColors.gallopsCheckboxColor,
                  ),

                  const SizedBox(height: 32),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to selection screen or implement track filtering
                        _navigateToTrackSelection(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.checkboxlist2Color,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Find Matching Tracks',
                        style: AppFonts.body6.copyWith(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.checkboxlist2Color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppFonts.titleRaceCourse.copyWith(
                  fontSize: 18,
                  color: AppColors.checkboxlist2Color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: AppFonts.body5.copyWith(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: AppFonts.titleRaceCourse.copyWith(
                  fontSize: 18,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8, right: 12),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: AppFonts.body5.copyWith(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _navigateToTrackSelection(BuildContext context) {
    // For now, just show a snackbar
    // Later, this could navigate to selection screen with pre-filtered tracks
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Feature coming soon: Find tracks matching ${scenario.title} criteria',
        ),
        backgroundColor: AppColors.checkboxlist2Color,
      ),
    );
  }
}
