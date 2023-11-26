

import 'package:flutteradvanced/features/feature_bookmark/data/data_source/local/database.dart';
import 'package:flutteradvanced/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:get_it/get_it.dart';

import 'features/feature_weather/data/data_source/remote/api_provider.dart';
import 'features/feature_weather/data/repository/weather_repositoryImpl.dart';
import 'features/feature_weather/domain/repository/weather_repository.dart';
import 'features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'features/feature_weather/presentation/bloc/home_bloc.dart';

GetIt locator=GetIt.instance;

setUp() async {
  locator.registerSingleton<ApiProvider>(ApiProvider());

  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  locator.registerSingleton<AppDatabase>(database);

  /// repositories
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));

  /// use cases
  locator.registerSingleton<GetCurrentWeatherUseCase>(GetCurrentWeatherUseCase(locator()));
  locator.registerSingleton<GetForecastWeatherUseCase>(GetForecastWeatherUseCase(locator()));

  locator.registerSingleton<HomeBloc>(HomeBloc(locator(),locator()));

}