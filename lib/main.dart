import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/background_bloc.dart';
import 'bloc/clock_bloc.dart';
import 'bloc/quotebloc_bloc.dart';
import 'homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink[800],
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => QuoteblocBloc()..add(QuoteUpdateEvent())),
          BlocProvider(
              create: (context) =>
                  BackgroundBloc()..add(BackgroundEventUpdate())),
          BlocProvider(
              create: (context) => ClockBloc()..add(ClockUpdateEvent())),
        ],
        child: HomePage(),
      ),
    );
  }
}
