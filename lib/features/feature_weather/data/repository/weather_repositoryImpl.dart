import 'package:dio/dio.dart';
import 'package:flutteradvanced/core/params/forecast_params.dart';
import 'package:flutteradvanced/features/feature_weather/data/models/forecastDaysModel.dart';
import 'package:flutteradvanced/features/feature_weather/data/models/suggest_city_model.dart';
import 'package:flutteradvanced/features/feature_weather/domain/entities/forecast_Days_entity.dart';
import 'package:flutteradvanced/features/feature_weather/domain/entities/suggest_city_entity.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/entities/current_city_entity.dart';
import '../../domain/repository/weather_repository.dart';
import '../data_source/remote/api_provider.dart';
import '../models/current_city_model.dart';

class WeatherRepositoryImpl extends WeatherRepository{
  ApiProvider  apiProvider;
  WeatherRepositoryImpl(this.apiProvider);
  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName) async {
      try{
      Response response=await apiProvider.callCurrentWeather(cityName);
      if(response.statusCode==200){
        CurrentCityEntity currentCityEntity=CurrentCityModel.fromJson(response.data);
        return DataSuccess(currentCityEntity);
      }else{
       return const DataFailed("Something went Wrong, try again...");
      }
      }catch(e){
        return const DataFailed("Connection Failed...");
      }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams params) async {
    try{
      Response response=await apiProvider.sendRequest7DaysForecast(params);
      if(response.statusCode==200){
        ForecastDaysEntity forecastDaysEntity=ForecastDaysModel.fromJson(response.data);
        return DataSuccess(forecastDaysEntity);
      }else{
        return const DataFailed("Something went Wrong, try again...");
      }
    }catch(e){
      return const DataFailed("Connection Failed...");
    }
  }

  @override
  Future<List<Data>> fetchSuggestData(cityName) async{

     Response response= await apiProvider.sendRequestCitySuggestion(cityName);
     SuggestCityEntity suggestCityEntity=SuggestCityModel.fromJson(response.data);
     return suggestCityEntity.data!;
  }
  
}