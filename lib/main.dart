import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutteradvanced/core/widgets/main_wrapper.dart';
import 'package:flutteradvanced/features/feature_weather/presentation/bloc/home_bloc.dart';

import 'features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// init locator
  await setup();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MultiBlocProvider(
          providers: [
        BlocProvider(create:(_) => locator<HomeBloc>()),
        BlocProvider(create: (_) => locator<BookmarkBloc>()),
          ],
      child: MainWrapper()
      ),
  ));
}
