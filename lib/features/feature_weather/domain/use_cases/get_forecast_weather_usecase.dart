import 'package:flutteradvanced/core/params/forecast_params.dart';
import 'package:flutteradvanced/core/resources/data_state.dart';
import 'package:flutteradvanced/core/usecase/use_case.dart';
import 'package:flutteradvanced/features/feature_weather/domain/entities/forecast_Days_entity.dart';
import 'package:flutteradvanced/features/feature_weather/domain/repository/weather_repository.dart';

class GetForecastWeatherUseCase implements UseCase<DataState<ForecastDaysEntity>,ForecastParams>{
  final WeatherRepository _weatherRepository;

  GetForecastWeatherUseCase(this._weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call(ForecastParams param) {
    return _weatherRepository.fetchForecastWeatherData(param);
  }
  
}