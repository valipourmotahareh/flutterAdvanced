import 'package:flutteradvanced/core/usecase/use_case.dart';
import 'package:flutteradvanced/features/feature_weather/domain/repository/weather_repository.dart';

import '../../data/models/suggest_city_model.dart';

class GetSuggestCityUseCase implements UseCase<List<Data>,String>{
  final WeatherRepository _weatherRepository;
  GetSuggestCityUseCase(this._weatherRepository);

  @override
  Future<List<Data>> call(String param) {
   return _weatherRepository.fetchSuggestData(param);
  }
  
}