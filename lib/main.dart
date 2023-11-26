import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteradvanced/core/widgets/main_wrapper.dart';
import 'package:flutteradvanced/features/feature_weather/presentation/bloc/home_bloc.dart';

import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// init locator
  await setUp();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MultiBlocProvider(
          providers: [
        BlocProvider(create:(_) => locator<HomeBloc>())
      ],
      child: MainWrapper()
      ),
  ));
}
