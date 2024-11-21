class GetWindQuality {
  Map<String, dynamic> getWindQualityFromSpeed(
      String windSpeed, List<Map<String, dynamic>> winddata) {
    // Step 1: Parse the wind speed and convert it to double
    String? value = windSpeed.replaceAll("km/h", "").trim();
    double parsedWindSpeed =
        double.tryParse(value) ?? 0.0;

    // Step 2: Loop through the winddata to find the matching condition
    for (var data in winddata) {
      String condition = data["Relevant Wind Speed (km/h)"];
      String windQuality = data["Wind Quality"];

      // Step 3: Check if the condition is a range (e.g., "10.44 - 20.16")
      if (condition.contains('-')) {
        // Extract the range
        var splitRange = condition.split('-');
        double minSpeed = double.parse(splitRange[0].trim());
        double maxSpeed = double.parse(splitRange[1].trim());

        // If parsedWindSpeed is within the range, return the result
        if (parsedWindSpeed >= minSpeed && parsedWindSpeed <= maxSpeed) {
          return {'quality': windQuality, 'relevantWindSpeed': condition};
        }
      } else {
        // If the condition is a maximum (e.g., "<= 10.08"), check if it's less than or equal to the value
        if (condition.startsWith("<=")) {
          double maxSpeed = double.parse(condition.replaceAll("<=", "").trim());
          if (parsedWindSpeed <= maxSpeed) {
            return {'quality': windQuality, 'relevantWindSpeed': condition};
          }
        } else if (condition.startsWith(">=")) {
          double minSpeed = double.parse(condition.replaceAll(">=", "").trim());
          if (parsedWindSpeed >= minSpeed) {
            return {'quality': windQuality, 'relevantWindSpeed': condition};
          }
        }
      }
    }

    // If no match found, return a default value
    return {
      'quality': 'Unknown',
      'relevantWindSpeed': 'No matching condition found'
    };
  }
}
