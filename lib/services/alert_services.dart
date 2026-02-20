// lib/services/alert_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/models/alert_model.dart'; 

class AlertService {
  final String _newsApiKey = dotenv.env['NEWS_API_KEY'] ?? '';
  final String _weatherApiKey = dotenv.env['OPENWEATHERMAP_API_KEY'] ?? '';

  static const Map<String, Map<String, double>> _cityCoordinates = {
    'Kerala': {'lat': 10.8505, 'lon': 76.2711},
    'Kochi': {'lat': 9.9312, 'lon': 76.2673},
    'Trivandrum': {'lat': 8.5241, 'lon': 76.9366},
    'Kozhikode': {'lat': 11.2588, 'lon': 75.7804},
    'Thrissur': {'lat': 10.5276, 'lon': 76.2144},
    'Kannur': {'lat': 11.8745, 'lon': 75.3704},
  };

  // --- UPDATED: The method now returns a Future of ScreenData ---
  Future<ScreenData> fetchScreenData({required String cityName}) async {
    final coordinates = _cityCoordinates[cityName]!;
    final lat = coordinates['lat'];
    final lon = coordinates['lon'];

    final String newsQuery = '$cityName India';
    final String newsApiUrl = 'https://newsapi.org/v2/everything?q=$newsQuery&sortBy=publishedAt&language=en&apiKey=$_newsApiKey';
    final String weatherApiUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$_weatherApiKey';

    final responses = await Future.wait([
      _safeFetch(newsApiUrl),
      _safeFetch(weatherApiUrl),
    ]);

    // Process news alerts (logic is the same)
    final List<Alert> alerts = [];
    if (responses[0] != null) {
      final decoded = json.decode(responses[0]!);
      if (decoded['articles'] != null) {
        for (var article in decoded['articles']) {
          if (article['title'] == '[Removed]' || article['title'] == null) continue;
          alerts.add(Alert(
            type: AlertType.news,
            title: article['title'],
            description: article['source']['name'] ?? 'No source available',
            timestamp: DateTime.parse(article['publishedAt']),
          ));
        }
      }
    }

    // Process weather info (logic is the same)
    WeatherInfo? weatherInfo;
    if (responses[1] != null) {
      final decoded = json.decode(responses[1]!);
      weatherInfo = WeatherInfo.fromJson(decoded);
    }
    
    // --- UPDATED: Return a single ScreenData object ---
    return ScreenData(alerts: alerts, weather: weatherInfo);
  }

  Future<String?> _safeFetch(String url) async {
    print('Fetching data from: $url');
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('Success fetching data.');
        return response.body;
      } else {
        print('--> FAILED request to $url with status code: ${response.statusCode}');
        print('--> Response Body: ${response.body}');
      }
    } catch (e) {
      print('--> FAILED to fetch data from $url: $e');
    }
    return null;
  }
}