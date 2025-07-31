class Scenario {
  final String id;
  final String title;
  final String description;
  final String icon;
  final ScenarioType type;
  final List<String> keyFactors;
  final List<String> idealConditions;
  final List<String> exampleTracks;

  const Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.keyFactors,
    required this.idealConditions,
    required this.exampleTracks,
  });

  static Scenario fromMap(Map<String, dynamic> data, String id) {
    return Scenario(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      type: switch (data['type']) {
        'longStraight' => ScenarioType.longStraight,
        'shortStraight' => ScenarioType.shortStraight,
        'shortFirstTurn' => ScenarioType.shortFirstTurn,
        'longFirstTurn' => ScenarioType.longFirstTurn,
        'strongWind' => ScenarioType.strongWind,
        'wideTrack' => ScenarioType.wideTrack,
        'narrowTrack' => ScenarioType.narrowTrack,
        'leftHanded' => ScenarioType.leftHanded,
        'rightHanded' => ScenarioType.rightHanded,
        _ => ScenarioType.longStraight, // Default case
      },
      keyFactors: List<String>.from(data['keyFactors'] ?? []),
      idealConditions: List<String>.from(data['idealConditions'] ?? []),
      exampleTracks: List<String>.from(data['exampleTracks'] ?? []),
    );
  }
}

enum ScenarioType {
  longStraight,
  shortStraight,
  shortFirstTurn,
  longFirstTurn,
  strongWind,
  wideTrack,
  narrowTrack,
  leftHanded,
  rightHanded,
}

extension ScenarioTypeExtension on ScenarioType {
  String get displayName {
    switch (this) {
      case ScenarioType.longStraight:
        return 'Long Straight';
      case ScenarioType.shortStraight:
        return 'Short Straight';
      case ScenarioType.shortFirstTurn:
        return 'Short 1st Turn';
      case ScenarioType.longFirstTurn:
        return 'Long 1st Turn';
      case ScenarioType.strongWind:
        return 'Strong Wind';
      case ScenarioType.wideTrack:
        return 'Wide Track';
      case ScenarioType.narrowTrack:
        return 'Narrow Track';
      case ScenarioType.leftHanded:
        return 'Left Handed';
      case ScenarioType.rightHanded:
        return 'Right Handed';
    }
  }

  String get emoji {
    switch (this) {
      case ScenarioType.longStraight:
        return '🏁';
      case ScenarioType.shortStraight:
        return '⚡';
      case ScenarioType.shortFirstTurn:
        return '🔄';
      case ScenarioType.longFirstTurn:
        return '↩️';
      case ScenarioType.strongWind:
        return '💨';
      case ScenarioType.wideTrack:
        return '↔️';
      case ScenarioType.narrowTrack:
        return '🔸';
      case ScenarioType.leftHanded:
        return '↪️';
      case ScenarioType.rightHanded:
        return '↩️';
    }
  }
}
