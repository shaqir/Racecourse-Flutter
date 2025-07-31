import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:racecourse_tracks/domain/models/scenario.dart';
import 'package:racecourse_tracks/ui/core/theme/appcolors.dart';
import 'package:racecourse_tracks/ui/core/theme/appfonts.dart';
import 'package:racecourse_tracks/ui/scenarios/view_model/scenarios_view_model.dart';
import 'package:racecourse_tracks/ui/scenarios/widgets/scenario_detail_screen.dart';

class ScenariosScreen extends StatelessWidget {
  final ScenariosViewModel viewModel;

  const ScenariosScreen({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Racing Scenarios',
          style: AppFonts.title1,
        ),
        backgroundColor: AppColors.checkboxlist2Color,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.checkboxlist2Color.withValues(alpha: 0.1),
                    AppColors.checkboxlist2Color.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 48,
                    color: AppColors.checkboxlist2Color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    viewModel.appTexts['scenarios_heading']?.value ?? '',
                    style: AppFonts.title.copyWith(
                      fontSize: 24,
                      color: AppColors.checkboxlist2Color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.appTexts['scenarios_description']?.value ?? '',
                    textAlign: TextAlign.center,
                    style: AppFonts.body5.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Scenarios horizontal list
            Container(
              height: 220,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, child) {
                  if (viewModel.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: viewModel.scenarios.length,
                    itemBuilder: (context, index) {
                      final scenario = viewModel.scenarios[index];
                      return Container(
                        width: 160,
                        margin: EdgeInsets.only(
                          right: index < viewModel.scenarios.length - 1 ? 16 : 0,
                        ),
                        child: _buildScenarioCard(context, scenario),
                      );
                    },
                  );
                },
              ),
            ),

            // Website promotion section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.checkboxlist2Color.withValues(alpha: 0.1),
                    AppColors.checkboxlist2Color.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.checkboxlist2Color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.language,
                    size: 32,
                    color: AppColors.checkboxlist2Color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Learn More Online',
                    style: AppFonts.titleRaceCourse.copyWith(
                      fontSize: 18,
                      color: AppColors.checkboxlist2Color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Visit our website for detailed racing guides, additional scenarios, and professional insights.',
                    textAlign: TextAlign.center,
                    style: AppFonts.body5.copyWith(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchWebsite(context),
                      icon: Icon(
                        Icons.open_in_browser,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Visit Racecourses.Tracks',
                        style: AppFonts.body6.copyWith(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.checkboxlist2Color,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildScenarioCard(BuildContext context, Scenario scenario) {
    return GestureDetector(
      onTap: () => _navigateToScenarioDetail(context, scenario),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey[300]!.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.checkboxlist2Color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    scenario.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                scenario.title,
                textAlign: TextAlign.center,
                style: AppFonts.titleRaceCourse.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Learn more indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.checkboxlist2Color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Learn More',
                  style: AppFonts.body2_1.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.checkboxlist2Color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToScenarioDetail(BuildContext context, Scenario scenario) {
    viewModel.selectScenario(scenario);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioDetailScreen(
          scenario: scenario,
          viewModel: viewModel,
        ),
      ),
    );
  }

  Future<void> _launchWebsite(BuildContext context) async {
    final Uri url = Uri.parse('https://racecoursestracks.com');
    
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open website. Please try again later.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening website: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
