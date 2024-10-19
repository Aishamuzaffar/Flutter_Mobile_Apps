import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String _apiKey = "3e8540b4b7d60c7adf79a12d6a8db28d"; //api key
  final String _apiUrl =
      "http://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}";

  final _cityController = TextEditingController();
  var _temperature;
  var _weatherDescription;
  bool _isLoading = false;
  bool _hasError = false;
  var _icon;
  var _humidity;
  var _windSpeed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 8.0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    hintText: 'Enter City Name',
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(Icons.location_city, color: Colors.black),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _fetchWeather(_cityController.text);
                  },
                  child: Text('Get Weather',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : _hasError
                        ? Center(
                            child: Text(
                              'Failed to load weather data',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : _temperature != null && _weatherDescription != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Temperature: ${_temperature.toStringAsFixed(2)}°C',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color.fromARGB(255, 9, 9, 9),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Weather: $_weatherDescription',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: const Color.fromARGB(255, 8, 8, 8),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  _icon != null
                                      ? SvgPicture.network(
                                          'http://openweathermap.org/img/w/$_icon.png', // Use SVG icon
                                          width: 100,
                                          height: 100,
                                        )
                                      : Container(),
                                  SizedBox(height: 20),
                                  _humidity != null
                                      ? Text(
                                          'Humidity: $_humidity%',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(255, 10, 10, 10),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(height: 20),
                                  _windSpeed != null
                                      ? Text(
                                          'Wind Speed: $_windSpeed m/s',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Color.fromARGB(255, 14, 14, 14),
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                            : Container(), // Empty container if no data
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchWeather(String cityName) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _temperature = null; // Clear previous data
      _weatherDescription = null; // Clear previous data
      _icon = null;
      _humidity = null;
      _windSpeed = null;
    });

    try {
      final response = await http.get(Uri.parse(_apiUrl
          .replaceAll("{city}", cityName)
          .replaceAll("{api_key}", _apiKey)));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _temperature = data['main']['temp'];
          _weatherDescription = data['weather'][0]['description'];
          _icon = data['weather'][0]['icon'];
          _humidity = data['main']['humidity'];
          _windSpeed = data['wind']['speed'];
        });
      } else {
        setState(() {
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
