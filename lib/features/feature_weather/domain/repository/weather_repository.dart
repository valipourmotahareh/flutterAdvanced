import 'package:flutteradvanced/core/params/forecast_params.dart';
import 'package:flutteradvanced/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:flutteradvanced/features/feature_weather/domain/entities/forecast_Days_entity.dart';

import '../../../../core/resources/data_state.dart';
import '../entities/current_city_entity.dart';

abstract class WeatherRepository{
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params);

  Future<List<Data>> fetchSuggestData(cityName);
}