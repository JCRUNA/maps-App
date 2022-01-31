import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/blocs/blocs.dart';
import 'package:maps/screens/loading_screen.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (BuildContext context) => GpsBloc()),
    BlocProvider(create: (BuildContext context) => LocationBloc())
  ], child: const MapsApp()));
}

class MapsApp extends StatelessWidget {
  const MapsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: LoadingScreen(),
    );
  }
}
