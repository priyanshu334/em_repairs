import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Check if already registered to avoid duplicates
  if (!locator.isRegistered<InternetConnectionChecker>()) {
    locator.registerLazySingleton<InternetConnectionChecker>(() => InternetConnectionChecker.createInstance());
  }
}
