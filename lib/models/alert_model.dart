// lib/models/alert_model.dart

// --- Wrapper Class to Hold All Screen Data ---
// This is the main object our screen will use.
class ScreenData {
  final List<Alert> alerts;
  final WeatherInfo? weather; // Weather can be null if the API call fails

  ScreenData({required this.alerts, this.weather});
}


// --- News Alert Model (as before) ---
class Alert {
  final String title;
  final String description;
  final DateTime timestamp;
  final AlertType type;

  Alert({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });
}

enum AlertType { news, disaster, weather } // Kept enum for flexibility


// --- Weather Model (Now inside this file) ---
class WeatherInfo {
  final String cityName;
  final String description;
  final String iconCode;
  final double temperature;

  WeatherInfo({
    required this.cityName,
    required this.description,
    required this.iconCode,
    required this.temperature,
  });

  // A factory constructor to easily create a WeatherInfo object from JSON
  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      temperature: json['main']['temp'].toDouble(),
    );
  }
}