class Scenario {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String type;
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
      type: data['type'],
      keyFactors: List<String>.from(data['keyFactors'] ?? []),
      idealConditions: List<String>.from(data['idealConditions'] ?? []),
      exampleTracks: List<String>.from(data['exampleTracks'] ?? []),
    );
  }
}

