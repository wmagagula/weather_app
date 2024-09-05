import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/weather_data.dart';
// import 'package:open_weather_example_flutter/src/features/weather/data/entities/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

const encodedWeatherJsonResponse = """
{
  "coord": {
    "lon": -122.08,
    "lat": 37.39
  },
  "weather": [
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 282.55,
    "feels_like": 281.86,
    "temp_min": 280.37,
    "temp_max": 284.26,
    "pressure": 1023,
    "humidity": 100
  },
  "visibility": 16093,
  "wind": {
    "speed": 1.5,
    "deg": 350
  },
  "clouds": {
    "all": 1
  },
  "dt": 1560350645,
  "sys": {
    "type": 1,
    "id": 5122,
    "message": 0.0139,
    "country": "US",
    "sunrise": 1560343627,
    "sunset": 1560396563
  },
  "timezone": -25200,
  "id": 420006353,
  "name": "Mountain View",
  "cod": 200
  }  
""";

final expectedWeatherFromJson = WeatherData.fromJson(jsonDecode(encodedWeatherJsonResponse));

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });
  test('repository with mocked http client, success', () async {
    final mockHttpClient = MockHttpClient();
    final uri = Uri(scheme: 'https', host: 'api.openweathermap.org', path: '/data/2.5/weather', queryParameters: {
      "q": 'London',
      "appid": 'apiKey',
      "units": "metric",
      "type": "like",
      "cnt": "30",
    });

    when(() => mockHttpClient.get(uri)).thenAnswer((_) =>
        Future.value(
          http.Response(encodedWeatherJsonResponse, 200),
        ));

    final api = OpenWeatherMapAPI('apiKey');
    final weatherRepository = HttpWeatherRepository(api: api, client: mockHttpClient);

    //act
    final response = await weatherRepository.getWeather(city: 'London');

    //assert
    verify(() => mockHttpClient.get(uri)).called(1);
    expect(response, same(expectedWeatherFromJson)); //this guy is acting funny...
  });

  test('repository with mocked http client, failure', () async {
    final mockHttpClient = MockHttpClient();
    when(() => mockHttpClient.get(any<Uri>())).thenAnswer((_) =>
        Future.value(
          http.Response("""Not Found""", 404),
        ));
    final api = OpenWeatherMapAPI('apiKey');
    final weatherRepository = HttpWeatherRepository(api: api, client: mockHttpClient);

    try {
      await weatherRepository.getWeather(city: 'London');
    } catch (e) {
      expect(e, CityNotFoundException);
    }
  });
}
