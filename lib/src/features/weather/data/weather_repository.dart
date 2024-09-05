import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/weather_data.dart';

class HttpWeatherRepository {
  HttpWeatherRepository({required this.api, required this.client});

  final OpenWeatherMapAPI api;
  final Client client;

  Future<WeatherData?> getWeather({required String city}) async {
    try {
      final response = await client.get(api.weather(city));
      if (response.statusCode == 200) {
        return WeatherData.fromJson(jsonDecode(response.body));
      }

      return await badRequest<WeatherData>(response.statusCode);
    } on SocketException catch (_) {
      return Future.error(NoInternetConnectionException);
    } catch (e) {
      debugPrint('Failed fetching weather data \n ${e.toString()}');
      return Future.error(e);
    }
  }

  Future<ForecastData?> getForecast({required String city}) async {
    try {
      final response = await client.get(api.forecast(city));
      return response.statusCode == 200
          ? ForecastData.fromJson(jsonDecode(response.body))
          : await badRequest<ForecastData>(response.statusCode);
    } catch (e) {
      debugPrint('Failed fetching forecast data');
      return Future.error(e);
    }

    return null;
  }

  Future<T>? badRequest<T>(int statusCode) {
    if (statusCode == 404) {
      return Future.error(CityNotFoundException);
    }
    return [401, 400].contains(statusCode) ? Future.error(InvalidApiKeyException) : null;
  }
}

void injectWeatherRepository() {
  final sl = GetIt.instance;

  sl.registerSingleton<HttpWeatherRepository>(
      HttpWeatherRepository(
        api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
        client: Client(),
      ),
      instanceName: 'weather_repo');
}
