import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';

import '../../helpers.dart';

class HttpWeatherRepositoryMock with Mock implements HttpWeatherRepository {}

void main() {
  test('get weather data should set weather and forecast data, if no error', () async {
    final httpWeatherRepositoryMock = HttpWeatherRepositoryMock();

    when(() => httpWeatherRepositoryMock.getWeather(city: 'London'))
        .thenAnswer((_) => Future.value(TestHelpers.expectedWeatherData));

    when(() => httpWeatherRepositoryMock.getForecast(city: 'London')).thenAnswer(
      (_) => Future.value(TestHelpers.expectedForecastData),
    );

    final weatherProvider = WeatherProvider(repository: httpWeatherRepositoryMock);

    //act
    await weatherProvider.getWeatherData();

    //assert
    expect(weatherProvider.currentWeatherProvider, TestHelpers.expectedWeatherData);
    expect(weatherProvider.hourlyWeatherProvider, TestHelpers.expectedForecastData);
  });

  test('switch unit should update temp', () async {
    final httpWeatherRepositoryMock = HttpWeatherRepositoryMock();

    final weatherProvider = WeatherProvider(repository: httpWeatherRepositoryMock);
    weatherProvider.currentWeatherProvider = TestHelpers.expectedWeatherData;
    weatherProvider.hourlyWeatherProvider = TestHelpers.expectedForecastData;

    //act
    weatherProvider.switchUnit(TemperatureUnit.fahrenheit);

    //assert
    expect(weatherProvider.temperatureUnit, TemperatureUnit.fahrenheit);
    expect(weatherProvider.currentWeatherProvider!.temp.temp, TestHelpers.expectedWeatherData.temp.fahrenheit);
    expect(weatherProvider.hourlyWeatherProvider!.hourlyForecasts[0].temp.temp, TestHelpers.expectedForecastData.hourlyForecasts[0].temp.fahrenheit);
  });
}
