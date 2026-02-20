import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  bool isLoading = true;
  Map<String, dynamic>? weatherData;
  List<dynamic> alerts = [];
  String locationName = "";

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    setState(() => isLoading = true);

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String location = "${position.latitude},${position.longitude}";
      String apiKey = dotenv.env['WEATHER_API_KEY'] ?? "";

      final response = await http.get(Uri.parse(
          "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$location&days=3&alerts=yes"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          weatherData = data;
          alerts = data["alerts"]["alert"] ?? [];
          locationName = data["location"]["name"];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case "severe":
        return Colors.red;
      case "moderate":
        return Colors.orange;
      case "minor":
        return Colors.yellow.shade700;
      default:
        return Colors.green;
    }
  }

  IconData getDisasterIcon(String text) {
    text = text.toLowerCase();
    if (text.contains("flood")) return Icons.flood;
    if (text.contains("storm")) return Icons.thunderstorm;
    if (text.contains("cyclone")) return Icons.cyclone;
    if (text.contains("landslide")) return Icons.terrain;
    return Icons.warning_amber_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Thanal Live Alerts"),
        backgroundColor: Colors.red.shade700,
        actions: [
          IconButton(
              onPressed: fetchAllData,
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchAllData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(12),
                children: [

                  /// 📍 LOCATION
                  Text("📍 $locationName",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  /// 🌤 CURRENT WEATHER
                  if (weatherData != null)
                    Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Image.network(
                          "https:${weatherData!["current"]["condition"]["icon"]}",
                          width: 50,
                        ),
                        title: Text(
                            "${weatherData!["current"]["temp_c"]}°C - ${weatherData!["current"]["condition"]["text"]}"),
                        subtitle: Text(
                            "Humidity: ${weatherData!["current"]["humidity"]}% | Wind: ${weatherData!["current"]["wind_kph"]} kph"),
                      ),
                    ),

                  const SizedBox(height: 15),

                  /// 🚨 ALERTS SECTION
                  const Text("🚨 Active Disaster Alerts",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  if (alerts.isEmpty)
                    const Text("No active disaster alerts in your area."),
                  
                  ...alerts.map((alert) {
                    String severity = alert["severity"] ?? "Moderate";

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              width: 6,
                              color: getSeverityColor(severity),
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(
                            getDisasterIcon(alert["headline"] ?? ""),
                            size: 35,
                            color: getSeverityColor(severity),
                          ),
                          title: Text(alert["headline"] ?? ""),
                          subtitle: Text(
                              "${alert["desc"] ?? ""}\n\nExpires: ${alert["expires"] ?? ""}"),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  /// 📅 FORECAST SECTION
                  const Text("📅 3-Day Forecast",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  if (weatherData != null)
                    ...weatherData!["forecast"]["forecastday"]
                        .map<Widget>((day) {
                      return Card(
                        child: ListTile(
                          leading: Image.network(
                            "https:${day["day"]["condition"]["icon"]}",
                            width: 40,
                          ),
                          title: Text(DateFormat.yMMMd()
                              .format(DateTime.parse(day["date"]))),
                          subtitle: Text(
                              "Max: ${day["day"]["maxtemp_c"]}°C | Min: ${day["day"]["mintemp_c"]}°C\n${day["day"]["condition"]["text"]}"),
                        ),
                      );
                    }).toList(),
                ],
              ),
      ),
    );
  }
}