import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutteradvanced/core/resources/data_state.dart';
import 'package:flutteradvanced/features/feature_weather/domain/entities/current_city_entity.dart';
import 'package:flutteradvanced/features/feature_weather/domain/use_cases/get_current_weather_usecase.dart';
import 'package:flutteradvanced/features/feature_weather/domain/use_cases/get_forecast_weather_usecase.dart';
import 'package:flutteradvanced/features/feature_weather/presentation/bloc/cw_status.dart';
import 'package:flutteradvanced/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:flutteradvanced/features/feature_weather/presentation/bloc/home_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([GetCurrentWeatherUseCase,GetForecastWeatherUseCase])
void main(){
  final MockGetCurrentWeatherUseCase mockGetCurrentWeatherUseCase=MockGetCurrentWeatherUseCase();
  final MockGetForecastWeatherUseCase mockGetForecastWeatherUseCase=MockGetForecastWeatherUseCase();
  const cityName='tehran';
  const error='error';
   group('cw Event test', () {
      when(mockGetCurrentWeatherUseCase.call(any)).thenAnswer((_) => Future.value(const DataSuccess(CurrentCityEntity())));
      blocTest<HomeBloc, HomeState>(
        'emit loading and completed state',
        build: () => HomeBloc(mockGetCurrentWeatherUseCase, mockGetForecastWeatherUseCase),
        act: (bloc) {
          bloc.add(LoadCwEvent(cityName));
        },
        expect: () => <HomeState>[
          HomeState(cwStatus: CwLoading(), fwStatus: FwLoading()),
          HomeState(cwStatus: CwCompleted(const CurrentCityEntity()), fwStatus: FwLoading()),

        ],
      );
   });
  /// Second Way
  test('emit Loading and Error state', () {
    when(mockGetCurrentWeatherUseCase.call(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

    final bloc = HomeBloc(mockGetCurrentWeatherUseCase,mockGetForecastWeatherUseCase);
    bloc.add(LoadCwEvent(cityName));

    expectLater(bloc.stream,emitsInOrder([
      HomeState(cwStatus: CwLoading(), fwStatus: FwLoading()),
      HomeState(cwStatus: CwError(error), fwStatus: FwLoading()),
    ]));
  });
}