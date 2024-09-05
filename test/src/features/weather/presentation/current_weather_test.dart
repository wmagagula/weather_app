import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/views/weather_page.dart';
import 'package:provider/provider.dart';

import '../../helpers.dart';
import '../application/providers_test.dart';

void main() {
  final httpWeatherRepoMock = HttpWeatherRepositoryMock();

  Widget wrapWithMaterialApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherProvider>(
            create: (_) => WeatherProvider(repository: httpWeatherRepoMock), lazy: false),
      ],
      child: MaterialApp(
        home: const WeatherPage(
          city: 'London',
        ),
        builder: EasyLoading.init(),
      ),
    );
  }

  testWidgets('ui elements must show', (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp());
    await tester.pump();

    expect(find.byKey(const Key('city_search_box')), findsOneWidget);
    expect(find.byKey(const Key('search_text_field')), findsOneWidget);
    expect(find.byKey(const Key('search_button')), findsOneWidget);
  });

  testWidgets('search box must not be empty, enter city name', (tester) async {
    await tester.pumpWidget(wrapWithMaterialApp());
    await tester.pump();

    await tester.enterText(find.byKey(const Key('search_text_field')), '');

    final searchButton = find.byKey(const Key('search_button'));
    await tester.ensureVisible(searchButton);
    await tester.tap(searchButton);

    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Please enter a city name'), findsOneWidget);
  });

  testWidgets('weather search for city, on success go to current weather', (tester) async {
    when(() => httpWeatherRepoMock.getWeather(city: 'London'))
        .thenAnswer((_) => Future.value(TestHelpers.expectedWeatherData));

    when(() => httpWeatherRepoMock.getForecast(city: 'London')).thenAnswer(
      (_) => Future.value(TestHelpers.expectedForecastData),
    );
    await tester.pumpWidget(wrapWithMaterialApp());
    await tester.pump();

    final searchButton = find.byKey(const Key('search_button'));
    await tester.ensureVisible(searchButton);
    await tester.tap(searchButton);

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('city_name')), findsOneWidget);
    expect(find.text('London'), findsOneWidget);
    expect(find.byKey(const Key('current_weather_contents')), findsOneWidget);
    expect(find.byKey(const Key('forecast_contents')), findsOneWidget);
    expect(find.byKey(const Key('display_units')), findsOneWidget);
    expect(find.byKey(const Key('back_button')), findsOneWidget);
  });
}
