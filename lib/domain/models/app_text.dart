class AppText {
  final String id;
  final String label;
  final String value;

  const AppText({
    required this.id,
    required this.label,
    required this.value,
  });

  factory AppText.fromJson(Map<String, dynamic> json) {
    return AppText(
      id: json['id'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'value': value,
    };
  }
}