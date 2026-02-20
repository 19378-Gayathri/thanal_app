// lib/screens/alert_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/services/alert_services.dart';
// Import everything from our single, combined model file
import '/models/alert_model.dart'; 

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  bool _isLoading = true;
  // --- UPDATED: A single state variable for all our data ---
  ScreenData? _screenData; 
  final AlertService _alertService = AlertService();

  String _selectedCity = 'Kerala';
  final List<String> _cities = [
    'Kerala', 'Kochi', 'Trivandrum', 'Kozhikode', 'Thrissur', 'Kannur',
  ];

  @override
  void initState() {
    super.initState();
    _fetchScreenData();
  }

  Future<void> _fetchScreenData() async {
    setState(() {
      _isLoading = true;
    });
    
    final fetchedData = await _alertService.fetchScreenData(cityName: _selectedCity);
    
    if (mounted) {
      setState(() {
        // --- UPDATED: Update the single state object ---
        _screenData = fetchedData; 
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kerala News & Weather'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: _selectedCity,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Colors.teal.shade700,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              underline: Container(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _selectedCity = newValue);
                  _fetchScreenData();
                }
              },
              items: _cities.map((value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              )).toList(),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchScreenData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // --- UPDATED: Check for weather data inside the ScreenData object ---
                  if (_screenData?.weather != null) _buildWeatherCard(_screenData!.weather!),

                  Expanded(child: _buildAlertList()), 
                ],
              ),
      ),
    );
  }

  Widget _buildWeatherCard(WeatherInfo weather) {
    // This widget's code does not need to change
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(weather.cityName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(weather.description.split(' ').map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' '), style: const TextStyle(fontSize: 16, color: Colors.black54)),
              ],
            ),
            Row(
              children: [
                Image.network('https://openweathermap.org/img/wn/${weather.iconCode}@2x.png', width: 50, height: 50),
                Text('${weather.temperature.round()}°C', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w300)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertList() {
    // --- UPDATED: Check for news data inside the ScreenData object ---
    if (_screenData == null || _screenData!.alerts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No recent news found for $_selectedCity. Pull down to refresh.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    }
    
    final alerts = _screenData!.alerts;
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0), 
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        final alert = alerts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 2,
          child: ListTile(
            leading: Icon(Icons.article, size: 40, color: Colors.teal.shade700),
            title: Text(alert.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${alert.description}\n${DateFormat.yMMMd().add_jm().format(alert.timestamp)}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}