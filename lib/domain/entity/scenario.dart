class Scenario {
  final String id;
  final String title;
  final String description;
  final String fullDescription;
  final String icon;
  final ScenarioType type;
  final List<String> keyFactors;
  final List<String> idealConditions;
  final List<String> exampleTracks;

  const Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.icon,
    required this.type,
    required this.keyFactors,
    required this.idealConditions,
    required this.exampleTracks,
  });
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
