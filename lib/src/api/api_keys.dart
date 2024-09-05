import 'package:get_it/get_it.dart';

/// To get an API key, sign up here:
/// https://home.openweathermap.org/users/sign_up
///

final sl = GetIt.instance;

void setupInjection() {
  // setup injection using 'api_key' instance name. Refer to https://pub.dev/packages/get_it for documentation
  sl.registerSingleton<String>('b12bd147130d91a4cfa1ba11855ac14d', instanceName: 'api_key');
}
