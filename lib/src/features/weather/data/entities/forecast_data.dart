import 'package:open_weather_example_flutter/src/features/weather/data/entities/shared/temparature.dart';

class ForecastData {
  ForecastData({required this.hourlyForecasts});

  final List<HourlyForecast> hourlyForecasts;

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    var hourlyForecasts = <HourlyForecast>[];
    json['list'].forEach((forecast) => {
          hourlyForecasts.add(HourlyForecast(
              temp: Temperature(temp: forecast['main']['temp']),
              date: DateTime.parse(forecast['dt_txt']),
              iconId: forecast['weather'][0]['icon']))
        });

    return ForecastData(hourlyForecasts: hourlyForecasts);
  }
}

class HourlyForecast {
  HourlyForecast({required this.temp, required this.date, required String iconId}) {
    iconUrl = _buildIconUrl(iconId);
  }

  final Temperature temp;
  final DateTime date;
  late String iconUrl;

  String _buildIconUrl(String iconId) => 'http://openweathermap.org/img/w/$iconId.png';
}
