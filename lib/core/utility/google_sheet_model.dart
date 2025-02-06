class GoogleSheetData {
  final Map<String, dynamic> data;

  GoogleSheetData({required this.data});

  factory GoogleSheetData.fromJson(Map<String, dynamic> json) {
    return GoogleSheetData(data: json);
  }
}
