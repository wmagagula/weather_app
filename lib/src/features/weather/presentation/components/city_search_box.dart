import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/views/current_weather.dart';
import 'package:provider/provider.dart';

class CitySearchBox extends StatefulWidget {
  const CitySearchBox({super.key});

  @override
  State<CitySearchBox> createState() => _CitySearchRowState();
}

class _CitySearchRowState extends State<CitySearchBox> {
  static const _radius = 30.0;

  late final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = context.read<WeatherProvider>().city;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // circular radius
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        height: _radius * 2,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('search_text_field'),
                    controller: _searchController,
                  ),
                ),
                InkWell(
                  key: const Key('search_button'),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(_radius),
                        bottomRight: Radius.circular(_radius),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('search', style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                  onTap: () async {
                    if (_searchController.text.isEmpty) {
                      EasyLoading.showError('Please enter a city name');
                      return;
                    }

                    FocusScope.of(context).unfocus();
                    context.read<WeatherProvider>().city = _searchController.text;
                    EasyLoading.show(status: 'Loading...');
                    await context.read<WeatherProvider>().getWeatherData().then((_) {
                      EasyLoading.dismiss();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CurrentWeather()),
                      );
                    }, onError: (e) {
                      //doesn't look pretty, works
                      switch (e) {
                        case CityNotFoundException _:
                          EasyLoading.showError(e.message);
                          break;
                        case NoInternetConnectionException _:
                          EasyLoading.showError(e.message);
                          break;
                        case InvalidApiKeyException _:
                          EasyLoading.showError(e.message);
                          break;
                        case UnknownException _:
                          EasyLoading.showError('Failed to load weather forecast!');
                          break;
                      }
                    });
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
