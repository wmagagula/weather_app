import 'package:open_weather_example_flutter/src/features/weather/data/entities/shared/temparature.dart';

class WeatherData {
  WeatherData({required this.temp, required this.maxTemp, required this.minTemp, required iconId}) {
    iconUrl = _buildIconUrl(iconId);
  }

  final Temperature temp;
  final Temperature minTemp;
  final Temperature maxTemp;
  late String iconUrl;

  String _buildIconUrl(String iconId) => 'http://openweathermap.org/img/w/$iconId.png';

  factory WeatherData.fromJson(Map<dynamic, dynamic> json) => WeatherData(
      temp: Temperature(temp: json['main']['temp']),
      maxTemp: Temperature(temp: json['main']['temp_max']),
      minTemp: Temperature(temp: json['main']['temp_min']),
      iconId: json['weather'][0]['icon']);
}
