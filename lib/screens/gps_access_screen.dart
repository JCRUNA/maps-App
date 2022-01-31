// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/blocs/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///voy a contruir la pantalla de acuerdo a mi estado de gps
      body: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          print('state: $state');
          return !state.isGpsEnabled
              ? const _EnableGpsMessage()
              : const _AccessButton();
        },
      ),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: Text('Es necesario el acceso al GPS')),
        MaterialButton(
            color: Colors.black,
            shape: const StadiumBorder(),
            elevation: 0,
            child: const Text(
              'Solicitar Acceso',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              //hago referencia a mi instancia de GpsBloc
              final gpsBloc = BlocProvider.of<GpsBloc>(context);
              gpsBloc.askGpsAccess();
              //OTRA FORMA
              //final gpsBloc = context.read<GpsBloc>();
            })
      ],
    );
  }
}

class _EnableGpsMessage extends StatelessWidget {
  const _EnableGpsMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Debe habilitar el GPS',
        style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
      ),
    );
  }
}
