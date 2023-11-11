

import 'package:get_it/get_it.dart';
import 'package:telcarnetflutter/features/feature_weather/data/data_source/remote/api_provider.dart';
import 'package:telcarnetflutter/features/feature_weather/data/repository/weather_repositoryImpl.dart';
import 'package:telcarnetflutter/features/feature_weather/domain/repository/weather_repository.dart';
import 'package:telcarnetflutter/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:telcarnetflutter/features/feature_weather/presentation/bloc/home_bloc.dart';

GetIt locator=GetIt.instance;

setUp(){
  locator.registerSingleton<ApiProvider>(ApiProvider());

  /// repositories
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));

  /// use cases
  locator.registerSingleton<GetCurrentWeatherUseCase>(GetCurrentWeatherUseCase(locator()));

  locator.registerSingleton<HomeBloc>(HomeBloc(locator()));

}