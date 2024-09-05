import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/components/current_weather_contents.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/components/display_units.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/components/forecast_contents.dart';
import 'package:provider/provider.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WeatherProvider, (String city, WeatherData? weatherData, ForecastData? forecastData)>(
        selector: (context, provider) =>
            (provider.city, provider.currentWeatherProvider, provider.hourlyWeatherProvider),
        builder: (context, data, _) {
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(key: const Key('city_name'), data.$1, style: Theme.of(context).textTheme.headlineMedium),
                CurrentWeatherContents(key: const Key('current_weather_contents'), data: data.$2!),
                ForecastContents(key: const Key('forecast_contents'), data: data.$3!),
                const DisplayUnits(key: Key('display_units'),),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    key: const Key('back_button'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Back')),
                )
              ],
            ),
          );
        });
  }
}
