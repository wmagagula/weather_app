import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/entities/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/components/weather_icon_image.dart';

import '../../../../constants/app_colors.dart';

class ForecastContents extends StatelessWidget {
  const ForecastContents({super.key, required this.data});

  final ForecastData data;

  String weekDay(int dayIndex) {
    return switch (dayIndex) {
      1 => 'Mon',
      2 => 'Tue',
      3 => 'Wed',
      4 => 'Thu',
      5 => 'Fri',
      6 => 'Sat',
      7 => 'Sun',
      _ => 'Day'
    };
  }

  List<HourlyForecast> getOneForecastPerDay() {
    Set<int> addedDatesIndex = {};

    return data.hourlyForecasts.where((forecast) {
      if (!addedDatesIndex.contains(forecast.date.weekday)) {
        addedDatesIndex.add(forecast.date.weekday);
        return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dailyForecasts = getOneForecastPerDay();

    return Container(
      margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.rainGradient,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...dailyForecasts.map((forecast) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  weekDay(forecast.date.weekday),
                  style: textTheme.bodyMedium,
                ),
                WeatherIconImage(iconUrl: forecast.iconUrl, size: 50),
                Text(
                  '${forecast.temp.celsius.toInt().toString()}°',
                  style: textTheme.bodyMedium,
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}

/*
* return Selector<WeatherProvider, (TemperatureUnit tempUnit)>(
    selector: (context, provider) =>
    (provider.temperatureUnit),
    builder: (context, data, _) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Unit(
              unit: 'C°',
              onTap: () {
                context.read<WeatherProvider>().switchUnit(TemperatureUnit.celsius);
              },
              style: context.read<WeatherProvider>().temperatureUnit == TemperatureUnit.celsius
                  ? selectedUnitStyle
                  : null,
            ),
            const SizedBox(
              width: 5,
            ),
            Unit(
              unit: 'F°',
              onTap: () {
                context.read<WeatherProvider>().switchUnit(TemperatureUnit.fahrenheit);
              },
              style: context.read<WeatherProvider>().temperatureUnit == TemperatureUnit.fahrenheit
                  ? selectedUnitStyle
                  : null,
            )
          ],
        ),
      );}
    );*/