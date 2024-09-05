import 'package:open_weather_example_flutter/src/features/weather/data/entities/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/shared/temparature.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/weather_data.dart';

class TestHelpers{
  static final expectedWeatherData = WeatherData(
      temp: Temperature(temp: 20),
      maxTemp: Temperature(temp: 29.2),
      minTemp: Temperature(temp: 14.55),
      iconId: 'iconId');

  static final expectedForecastData = ForecastData(hourlyForecasts: [
    HourlyForecast(temp: Temperature(temp: 32.0), date: DateTime.now(), iconId: 'iconId'),
    HourlyForecast(temp: Temperature(temp: 12.04), date: DateTime.now(), iconId: 'iconId'),
  ]);
}