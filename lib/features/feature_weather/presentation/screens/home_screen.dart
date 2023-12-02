import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutteradvanced/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:flutteradvanced/features/feature_weather/domain/use_cases/get_suggest_city_usecase.dart';
import 'package:flutteradvanced/features/feature_weather/presentation/bloc/fw_status.dart';
import 'package:flutteradvanced/features/feature_weather/presentation/widgets/bookmark_icon.dart';
import 'package:flutteradvanced/features/feature_weather/presentation/widgets/day_weather_view.dart';
import 'package:flutteradvanced/locator.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/params/forecast_params.dart';
import '../../../../core/utilis/date_converter.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/dot_loading_widget.dart';
import '../../data/models/forecastDaysModel.dart';
import '../../data/models/suggest_city_model.dart';
import '../../domain/entities/current_city_entity.dart';
import '../../domain/entities/forecast_Days_entity.dart';
import '../bloc/cw_status.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin{
  TextEditingController textEditingController=TextEditingController();
  GetSuggestCityUseCase getSuggestCityUseCase=GetSuggestCityUseCase(locator());
  String cityName="tehran";
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(cityName));
  }
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// ارتفاع از بالا ۲ درصد فاصله داشته باشه
            SizedBox(height: height * 0.02,),

            Padding(
              padding:  EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Row(
                children: [
                  /// search box
                  Expanded(
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        onSubmitted: (String prefix){
                          /// show text in textField
                          textEditingController.text=prefix;
                          /// call event for get current weather
                          BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(prefix));
                        },
                        controller: textEditingController,
                        style: DefaultTextStyle.of(context).style.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          hintText: "Enter a City.... ",
                          hintStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                        suggestionsCallback: (String prefix){
                          /// call api
                        return getSuggestCityUseCase.call(prefix);
                         },
                        itemBuilder: (context,Data model){
                          return ListTile(
                            leading: const Icon(Icons.location_on),
                            title: Text(model.name!),
                            subtitle: Text("${model.region!},${model.country!}"),
                          );
                        },
                        onSuggestionSelected: (Data model){
                          /// show text in textField
                          textEditingController.text=model.name!;
                          /// call event for get current weather
                          BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(model.name!));
                        }),
                  ),
                  const SizedBox(width: 10,),

                  BlocBuilder<HomeBloc,HomeState>(
                    buildWhen: (previous,current){
                         if(previous.cwStatus==current.cwStatus){
                           return false;
                         }
                         return true;
                    },
                    builder: (context,state){
                      /// show loading state for Cw
                      if(state.cwStatus is CwLoading){
                        return const CircularProgressIndicator();
                      }
                      /// show Error state for Cw
                      if(state.cwStatus is CwError){
                        return IconButton(
                            onPressed: (){

                            },
                            icon: const Icon(Icons.error,color: Colors.white,size: 35,));
                      }
                      /// show component for state complete Cw
                      if(state.cwStatus is CwCompleted){
                        final CwCompleted cwCompleted=state.cwStatus as CwCompleted;
                        BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(cwCompleted.currentCityEntity.name!));
                        return BookMarkIcon(name: cwCompleted.currentCityEntity.name!);
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            ),
            /// main ui
            BlocBuilder<HomeBloc,HomeState>(
              buildWhen: (previous,current){
                /// rebuild just when CwStatus changed
                if(previous.cwStatus==current.cwStatus){
                  return false;
                }
                return true;
              },
                builder: (context,state){
                  if(state.cwStatus is CwLoading){
                    return const Expanded(child: DotLoadingWidget());
                  }
                  if(state.cwStatus is CwCompleted){
                    /// cast
                    final CwCompleted cwCompleted=state.cwStatus as CwCompleted;
                    final CurrentCityEntity currentCityEntity=cwCompleted.currentCityEntity;

                    /// create params for api call
                    final ForecastParams forecastParams= ForecastParams(currentCityEntity.coord!.lat!,currentCityEntity.coord!.lon!);
                    /// start load FW event
                    BlocProvider.of<HomeBloc>(context).add(LoadFwEvent(forecastParams));

                    /// change Times to Hour
                    final sunrise=DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunrise, currentCityEntity.timezone);
                    final sunset=DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunset, currentCityEntity.timezone);
                    return  Expanded(
                        child: ListView(
                          children: [
                            Padding(padding: EdgeInsets.only(top: height * 0.02),
                            child: SizedBox(
                              width: width,
                              height: 400,
                              child: PageView.builder(itemBuilder:(context,position){
                                if(position==0){
                                   return Column(
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.only(top: 50),
                                         child: Text(
                                           currentCityEntity.name!,
                                           style: const TextStyle(fontSize: 30,color: Colors.white),),
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 20),
                                         child: Text(
                                           currentCityEntity.weather![0].description!,
                                           style: const TextStyle(fontSize: 20,color: Colors.grey),),
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 20),
                                         child: AppBackground.setIconForMain(currentCityEntity.weather![0].description!),
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 20),
                                         child: Text(
                                           "${currentCityEntity.main!.temp!.round()}\u00B0",
                                           style: const TextStyle(fontSize: 50,color: Colors.white),),
                                       ),
                                       const SizedBox(
                                         height: 20,
                                       ),
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           /// max temp
                                           Column(
                                             children: [
                                               const Text(
                                                 "max",
                                                 style: TextStyle(
                                                   fontSize: 16,
                                                   color: Colors.grey,
                                                 ),
                                               ),
                                               const SizedBox(
                                                 height: 10,
                                               ),
                                               Text(
                                                 "${currentCityEntity.main!.tempMax!.round()}\u00B0",
                                                 style: const TextStyle(fontSize: 16,color: Colors.white),
                                               ),
                                             ],
                                           ),
                                           /// divider
                                           Padding(padding:const EdgeInsets.only(left: 10.0,right: 10,),
                                             child: Container(
                                               color: Colors.grey,
                                               width: 2,
                                               height: 40,
                                             ),),
                                           /// min temp
                                           Column(
                                             children: [
                                               const Text(
                                                 "min",
                                                 style: TextStyle(
                                                   fontSize: 16,
                                                   color: Colors.grey,
                                                 ),
                                               ),
                                               const SizedBox(
                                                 height: 10,
                                               ),
                                               Text(
                                                 "${currentCityEntity.main!.tempMax!.round()}\u00B0",
                                                 style: const TextStyle(fontSize: 16,color: Colors.white),
                                               ),
                                             ],
                                           ),
                                         ],
                                       )
                                     ],

                                   );
                                }else{
                                  return Container(
                                    color: Colors.amber,
                                  );
                                }
                              },
                              physics: const AlwaysScrollableScrollPhysics(),
                              allowImplicitScrolling:true,
                              controller: _pageController,
                              itemCount: 2,
                              ),
                            ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                             /// pageView Indicator
                             Center(
                              child: SmoothPageIndicator(
                                count: 2,
                                controller: _pageController,
                                effect:const ExpandingDotsEffect(
                                  dotWidth: 10,
                                  dotHeight: 10,
                                  spacing: 5,
                                  activeDotColor: Colors.white,),
                                    onDotClicked: (index) =>
                                        _pageController.animateToPage
                                          (index, duration: const Duration(milliseconds: 500), curve: Curves.bounceOut,)
                                ),

                              ),
                            /// divider
                            Padding(padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              color: Colors.white24,
                              height: 2,
                              width: double.infinity,
                            ),),
                            /// forecast weather 7 days
                            Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 100,
                                  child: Padding(
                                    padding:const EdgeInsets.only(left: 10.0),
                                    child: Center(
                                      child: BlocBuilder<HomeBloc,HomeState>(
                                          builder: (BuildContext context,state){
                                            /// show loading state for FW
                                            if(state.fwStatus is FwLoading){
                                              return const DotLoadingWidget();
                                            }
                                            /// show Completed state for Fw
                                            if(state.fwStatus is FwCompleted){
                                              /// casting
                                              final FwCompleted fwCompleted=state.fwStatus as FwCompleted;
                                              final ForecastDaysEntity forecastDaysEntity= fwCompleted.forecastDaysEntity;
                                              final List<Daily> mainDaily=forecastDaysEntity.daily!;
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: 8,
                                                  itemBuilder: (BuildContext context,int index,){
                                                  return DaysWeatherView(daily: mainDaily[index]);

                                                  },);
                                            }

                                            /// show Error state for FW
                                            if(state.fwStatus is FwError){
                                              final FwError fwError=state.fwStatus as FwError;
                                              return Center(
                                                child: Text(fwError.message!),
                                              );
                                            }

                                            /// show Default state foe FW
                                            return Container();
                                          },
                                      ),
                                    ),
                                  ),
                                ),),
                            /// divider
                            Padding(padding: const EdgeInsets.only(top: 15),
                              child: Container(
                                color: Colors.white24,
                                height: 2,
                                width: double.infinity,
                              ),),

                            /// last row
                            const SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// wind speed
                                Column(
                                  children: [
                                    Text("wind speed",
                                    style: TextStyle(
                                      fontSize: height * 0.017,color: Colors.amber
                                    ),),
                                    Padding(padding: const EdgeInsets.only(top: 10.0),
                                    child: Text("${currentCityEntity.wind!.speed!} m/s",
                                      style: TextStyle(
                                        fontSize: height * 0.016,
                                        color: Colors.white,
                                      ),
                                    ),
                                    ),
                                  ],
                                ),
                                Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Container(
                                  color: Colors.white24,
                                  height: 30,
                                  width: 2,
                                ),
                                ),
                                /// sunrise
                                Column(
                                  children: [
                                    Text("sunrise",
                                      style: TextStyle(
                                          fontSize: height * 0.017,color: Colors.amber
                                      ),),
                                    Padding(padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(sunrise,
                                        style: TextStyle(
                                          fontSize: height * 0.016,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Container(
                                    color: Colors.white24,
                                    height: 30,
                                    width: 2,
                                  ),
                                ),
                                /// sunset
                                Column(
                                  children: [
                                    Text("sunset",
                                      style: TextStyle(
                                          fontSize: height * 0.017,color: Colors.amber
                                      ),),
                                    Padding(padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(sunset,
                                        style: TextStyle(
                                          fontSize: height * 0.016,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(padding: const EdgeInsets.only(left: 10,right: 10),
                                  child: Container(
                                    color: Colors.white24,
                                    height: 30,
                                    width: 2,
                                  ),
                                ),
                                /// humidity
                                Column(
                                  children: [
                                    Text("humidity",
                                      style: TextStyle(
                                          fontSize: height * 0.017,color: Colors.amber
                                      ),),
                                    Padding(padding: const EdgeInsets.only(top: 10.0),
                                      child: Text('${currentCityEntity.main!.humidity}%',
                                        style: TextStyle(
                                          fontSize: height * 0.016,
                                          color: Colors.white,
                                         ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30,),

                          ],
                        ));

                  }
                  if(state.cwStatus is CwError){
                    return const Center(child: Text("Error"),);
                  }
                  return Container();
                }
            )

          ],
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}
