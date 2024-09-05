import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:provider/provider.dart';

class DisplayUnits extends StatelessWidget {
  const DisplayUnits({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedUnitStyle = OutlinedButton.styleFrom(backgroundColor: AppColors.rainBlueLight);

    return Selector<WeatherProvider, TemperatureUnit>(
        selector: (context, provider) => (provider.temperatureUnit),
        builder: (context, tempUnit, _) {
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
                  style: tempUnit == TemperatureUnit.celsius
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
                  style: tempUnit == TemperatureUnit.fahrenheit
                      ? selectedUnitStyle
                      : null,
                )
              ],
            ),
          );
        });
  }
}

class Unit extends StatelessWidget {
  const Unit({super.key, required this.unit, required this.onTap, this.style});

  final String unit;
  final VoidCallback onTap;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: style,
      child: Text(unit),
    );
  }
}
