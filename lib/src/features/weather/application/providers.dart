import 'package:flutter/cupertino.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherProvider({required HttpWeatherRepository repository}) : _repository = repository;

  final HttpWeatherRepository _repository;

  String city = 'London';
  WeatherData? currentWeatherProvider;
  ForecastData? hourlyWeatherProvider;
  bool _isLoading = false;
  TemperatureUnit _temperatureUnit = TemperatureUnit.celsius;

  bool get isLoading => _isLoading;

  TemperatureUnit get temperatureUnit => _temperatureUnit;

  Future<void> getWeatherData() async {
    _isLoading = true;
    final weather = await _repository.getWeather(city: city);
    currentWeatherProvider = weather;
    await getForecastData();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getForecastData() async {
    hourlyWeatherProvider = await _repository.getForecast(city: city);
  }

  void switchUnit(TemperatureUnit temperatureUnit) {
    switch (temperatureUnit) {
      case TemperatureUnit.celsius:
        currentWeatherProvider?.temp.temp = currentWeatherProvider!.temp.celsius;
        hourlyWeatherProvider?.hourlyForecasts.forEach((forecast) {
          forecast.temp.temp = forecast.temp.celsius;
        });
      case TemperatureUnit.fahrenheit:
        currentWeatherProvider?.temp.temp = currentWeatherProvider!.temp.fahrenheit;
        hourlyWeatherProvider?.hourlyForecasts.forEach((forecast) {
          forecast.temp.temp = forecast.temp.fahrenheit;
        });
    }

    _temperatureUnit = temperatureUnit;
    notifyListeners();
  }
}

enum TemperatureUnit { celsius, fahrenheit }
