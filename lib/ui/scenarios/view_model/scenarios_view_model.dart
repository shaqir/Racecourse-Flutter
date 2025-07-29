import 'package:flutter/foundation.dart';
import 'package:racecourse_tracks/domain/entity/scenario.dart';

class ScenariosViewModel extends ChangeNotifier {
  bool _loading = false;
  List<Scenario> _scenarios = [];
  Scenario? _selectedScenario;

  bool get loading => _loading;
  List<Scenario> get scenarios => _scenarios;
  Scenario? get selectedScenario => _selectedScenario;

  ScenariosViewModel() {
    _initializeScenarios();
  }

  void _initializeScenarios() {
    _loading = true;
    notifyListeners();
    _scenarios = [
      Scenario(
        id: '1',
        title: 'Long Straight Scenario',
        description: 'Runner regularly starts at racecourses with short straights. Runner runs on strongly but never wins.',
        fullDescription: 'Runner regularly starts at racecourses with short straights. Runner runs on strongly but never wins. On a calm day at a track with a wide long straight its chances are improved.\n\nThis scenario benefits horses that:\n• Have a strong finishing kick\n• Need time to build momentum\n• Struggle in tight finishes\n• Excel when given space to run',
        icon: '🏁',
        type: ScenarioType.longStraight,
        keyFactors: [
          'Home straight length > 400m',
          'Wide track width',
          'Calm wind conditions',
          'Good track surface'
        ],
        idealConditions: [
          'Straight length: 450m+',
          'Track width: 25m+',
          'Wind speed: < 15km/h',
          'Track condition: Good/Firm'
        ],
        exampleTracks: [
          'Flemington (450m straight)',
          'Royal Ascot (400m straight)',
          'Epsom (413m straight)'
        ],
      ),
      Scenario(
        id: '2',
        title: 'Short Straight Scenario',
        description: 'Runner regularly starts well and leads but in long straight racecourses struggles to hold on.',
        fullDescription: 'Runner regularly starts well and leads but in long straight racecourses struggles to hold on. Trainer places it on a racecourse with a short straight. Its chances are improved.\n\nThis scenario benefits horses that:\n• Are natural front runners\n• Have early speed but limited stamina\n• Excel in sprint finishes\n• Struggle when challenged late',
        icon: '⚡',
        type: ScenarioType.shortStraight,
        keyFactors: [
          'Home straight length < 300m',
          'Quick acceleration needed',
          'Front running tactics',
          'Sprint finish advantage'
        ],
        idealConditions: [
          'Straight length: < 280m',
          'Track width: Any',
          'Fast pace early',
          'Good barrier draw'
        ],
        exampleTracks: [
          'Happy Valley (250m straight)',
          'Chester (240m straight)',
          'Belmont Park (290m straight)'
        ],
      ),
      Scenario(
        id: '3',
        title: 'Short 1st Turn Scenario',
        description: 'Quick positioning advantage with minimal distance to first turn.',
        fullDescription: 'Horses that need to secure an early position benefit from tracks with short runs to the first turn. This minimizes the risk of being caught wide and allows tactical positioning early in the race.\n\nThis scenario benefits horses that:\n• Need to secure early position\n• Have tactical speed\n• Work well when settled\n• Benefit from barrier position',
        icon: '🔄',
        type: ScenarioType.shortFirstTurn,
        keyFactors: [
          'Distance to 1st turn < 200m',
          'Quick positioning crucial',
          'Barrier draw important',
          'Early tactical speed needed'
        ],
        idealConditions: [
          '1st turn distance: < 180m',
          'Inside barrier draw',
          'Moderate early pace',
          'Good track conditions'
        ],
        exampleTracks: [
          'Moonee Valley (160m to turn)',
          'Canterbury (170m to turn)',
          'Warwick Farm (185m to turn)'
        ],
      ),
      Scenario(
        id: '4',
        title: 'Long 1st Turn Scenario',
        description: 'Extended run allows settling and positioning flexibility.',
        fullDescription: 'Tracks with long runs to the first turn allow horses more time to settle and find their preferred position. This suits horses that need time to balance up and find their rhythm.\n\nThis scenario benefits horses that:\n• Need time to settle\n• Benefit from patient riding\n• Can overcome barrier disadvantage\n• Excel when finding rhythm early',
        icon: '↩️',
        type: ScenarioType.longFirstTurn,
        keyFactors: [
          'Distance to 1st turn > 400m',
          'Time to settle important',
          'Barrier draw less critical',
          'Patient riding tactics'
        ],
        idealConditions: [
          '1st turn distance: > 450m',
          'Any barrier draw',
          'Steady early pace',
          'Good track surface'
        ],
        exampleTracks: [
          'Flemington (500m+ to turn)',
          'Caulfield (450m to turn)',
          'Royal Randwick (480m to turn)'
        ],
      ),
      Scenario(
        id: '5',
        title: 'Strong Wind Scenario',
        description: 'Wind conditions significantly impact racing tactics and outcomes.',
        fullDescription: 'Strong wind conditions can dramatically affect race outcomes, particularly influencing pace and positioning tactics. Headwinds favor on-pace runners while tailwinds can create faster times and benefit closers.\n\nThis scenario considers:\n• Wind direction and strength\n• Impact on pace and positioning\n• Jockey tactical adjustments\n• Track configuration effects',
        icon: '💨',
        type: ScenarioType.strongWind,
        keyFactors: [
          'Wind speed > 25km/h',
          'Wind direction impact',
          'Pace adjustment needed',
          'Positioning strategy crucial'
        ],
        idealConditions: [
          'Headwind: Favor on-pace',
          'Tailwind: Favor closers',
          'Crosswind: Consider draw',
          'Consistent wind direction'
        ],
        exampleTracks: [
          'Any exposed track',
          'Coastal racecourses',
          'Open terrain venues'
        ],
      ),
      Scenario(
        id: '6',
        title: 'Wide Track Scenario',
        description: 'Spacious tracks allow for varied tactical options and late runs.',
        fullDescription: 'Wide tracks provide more racing room and tactical options, particularly benefiting horses that need space to maneuver and those with strong finishing kicks. The extra width reduces crowding and allows for multiple racing lines.\n\nThis scenario benefits horses that:\n• Need racing room\n• Have strong finishing sprints\n• Benefit from wide runs\n• Excel when not crowded',
        icon: '↔️',
        type: ScenarioType.wideTrack,
        keyFactors: [
          'Track width > 25m',
          'Multiple racing lines',
          'Reduced crowding',
          'Tactical flexibility'
        ],
        idealConditions: [
          'Track width: > 28m',
          'Good track surface',
          'Moderate pace',
          'Quality field spread'
        ],
        exampleTracks: [
          'Royal Ascot (30m+ wide)',
          'Flemington (27m wide)',
          'Epsom (wide configuration)'
        ],
      ),
    ];
    _loading = false;
    notifyListeners();
  }

  void selectScenario(Scenario scenario) {
    _selectedScenario = scenario;
    notifyListeners();
  }

  void clearSelection() {
    _selectedScenario = null;
    notifyListeners();
  }

  List<Scenario> getScenariosByType(ScenarioType type) {
    return _scenarios.where((scenario) => scenario.type == type).toList();
  }

  Scenario? getScenarioById(String id) {
    try {
      return _scenarios.firstWhere((scenario) => scenario.id == id);
    } catch (e) {
      return null;
    }
  }
}
