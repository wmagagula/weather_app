import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/views/weather_page.dart';
import 'package:provider/provider.dart';

void main() {
  setupInjection();
  injectWeatherRepository();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyleWithShadow = TextStyle(color: Colors.white, shadows: [
      BoxShadow(
        color: Colors.black12.withOpacity(0.25),
        spreadRadius: 1,
        blurRadius: 4,
        offset: const Offset(0, 0.5),
      )
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherProvider>(
            create: (_) => WeatherProvider(repository: sl<HttpWeatherRepository>(instanceName: 'weather_repo')),
            lazy: false),
      ],
      child: MaterialApp(
          title: 'Open Weather',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            brightness: Brightness.dark,
            textTheme: TextTheme(
              displayLarge: textStyleWithShadow,
              displayMedium: textStyleWithShadow,
              displaySmall: textStyleWithShadow,
              headlineMedium: textStyleWithShadow,
              headlineSmall: textStyleWithShadow,
              titleMedium: const TextStyle(color: Colors.white),
              bodyMedium: const TextStyle(color: Colors.white),
              bodyLarge: const TextStyle(color: Colors.white),
              bodySmall: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          builder: EasyLoading.init(),
          home: const WeatherPage(city: 'London')),
    );
  }
}
