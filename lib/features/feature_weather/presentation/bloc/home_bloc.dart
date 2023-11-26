import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutteradvanced/core/params/forecast_params.dart';
import 'package:flutteradvanced/features/feature_weather/presentation/bloc/fw_status.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/use_cases/get_current_weather_usecase.dart';
import '../../domain/use_cases/get_forecast_weather_usecase.dart';
import 'cw_status.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetForecastWeatherUseCase _getForecastWeatherUseCase;
  HomeBloc(this.getCurrentWeatherUseCase,this._getForecastWeatherUseCase) :
        super(HomeState(cwStatus: CwLoading(), fwStatus: FwLoading())) {
    on<LoadCwEvent>((event, emit) async{
      emit(state.copyWith(newCwStatus: CwLoading()));

      DataState dataState= await getCurrentWeatherUseCase(event.cityName);

      if(dataState is DataSuccess){
        emit(state.copyWith(newCwStatus:  CwCompleted(dataState.data)));
      }
      if(dataState is DataFailed){
         emit(state.copyWith(newCwStatus: CwError(dataState.error!)));
      }
    });

    /// load 7 days Forecast weather for city event
    on<LoadFwEvent>((event, emit) async{
        emit(state.copyWith(newFwStatus: FwLoading()));
        DataState dataState=await _getForecastWeatherUseCase(event.params);
        if(dataState is DataSuccess){
          emit(state.copyWith(newFwStatus:FwCompleted(dataState.data)));
        }
        if(dataState is DataFailed){
           emit(state.copyWith(newFwStatus: FwError(dataState.error!)));
        }
    });
  }
}
