import 'package:flutter/material.dart';
import 'package:racecourse_tracks/domain/entity/scenario.dart';
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
      body: SafeArea(
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
                    'Strategic Racing Insights',
                    style: AppFonts.title.copyWith(
                      fontSize: 24,
                      color: AppColors.checkboxlist2Color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Discover how track conditions and characteristics\ncan impact racing outcomes',
                    textAlign: TextAlign.center,
                    style: AppFonts.body5.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Scenarios grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListenableBuilder(
                  listenable: viewModel,
                  builder: (context, child) {
                    if (viewModel.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: viewModel.scenarios.length,
                      itemBuilder: (context, index) {
                        final scenario = viewModel.scenarios[index];
                        return _buildScenarioCard(context, scenario);
                      },
                    );
                  },
                ),
              ),
            ),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.checkboxlist2Color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    scenario.icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Title
              Text(
                scenario.title,
                textAlign: TextAlign.center,
                style: AppFonts.titleRaceCourse.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Learn more indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.checkboxlist2Color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Learn More',
                  style: AppFonts.body2_1.copyWith(
                    fontSize: 11,
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
}
