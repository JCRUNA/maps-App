import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

part 'gps_event.dart';
part 'gps_state.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  StreamSubscription? gpsServiceSubscription;

  GpsBloc()
      : super(const GpsState(
            isGpsEnabled: false, isGpsPermissionGranted: false)) {
    ///estado inicial
    on<GpsPermissionEvent>((event, emit) {
      emit(state.copyWith(
          isGpsEnabled: event.isGpsEnabled,
          isGpsPermissionGranted: event.isGpsPermissionGranted));
    });

    _init();
  }

  ///cuando en el main en el multiblocProvider se crea la instancia de GpsBloc mediante el contructor,
  ///entonces se ejecuta este metodo _init
  Future<void> _init() async {
    final isEnabled = await _checkGpsStatus();
    final isGranted = await _isPermissionGranted();

    ///para disparar los 2 metodos future en simultaneo lo que hago es usar el Future.wait y le pasamos una lista
    ///de futures.
    final List<bool> gpsInitStatus = await Future.wait([
      _checkGpsStatus(),
      _isPermissionGranted(),
    ]);

    add(GpsPermissionEvent(
        isGpsEnabled: gpsInitStatus[0],
        isGpsPermissionGranted: gpsInitStatus[1]));
  }

  Future<bool> _isPermissionGranted() async {
    final isGranted = await Permission.location.isGranted;
    return isGranted;
  }

  //metodo que verifica el estado del gps
  Future<bool> _checkGpsStatus() async {
    ///con el metodo del paquete Geolocator llamado isLocationServiceEnabled
    ///voy a saber si el servicio esta habilitado o no
    final isEnabled = await Geolocator.isLocationServiceEnabled();

    ///como no podemos hacer un emit dentro de un metodo lo que hacemos es usar el
    ///metod add que notifica al bloc cuando un evento es disparado.
    add(GpsPermissionEvent(
        isGpsEnabled: isEnabled,
        isGpsPermissionGranted: state.isGpsPermissionGranted));

    ///mediante el metodo getServiceStatusStream voy a estar escuchando los eventos para
    ///saber si mi servicio esta habilitado. El event es de tipo ServiceState.
    ///Service state es 1 si el gps esta activado y 0 si esta desactivado.
    ///Si en mi celu desactivo el gps entonces como este metodo escucha los cambios se va a
    ///ejecutar y va a imprimir service status:false . Si lo vuelvo a activar
    /// como cambia el estado va a imprimir ServiceStatus: true

    gpsServiceSubscription =
        Geolocator.getServiceStatusStream().listen((event) {
      final isEnabled = ((event.index) == 1) ? true : false;
      print('service status: $isEnabled');

      ///como no podemos hacer un emit dentro de un metodo lo que hacemos es usar el
      ///metod add que notifica al bloc cuando un evento es disparado.
      add(GpsPermissionEvent(
          isGpsEnabled: isEnabled,
          isGpsPermissionGranted: state.isGpsPermissionGranted));
      //to do disparar eventos
    });

    return isEnabled;
  }

  ///metodo para pregunar si damos permiso al gps
  Future<void> askGpsAccess() async {
    final status = await Permission.location.request();
    switch (status) {
      case PermissionStatus.denied:
        // TODO: Handle this case.
        break;
      case PermissionStatus.granted:

        ///en caso que demos acceso al gps
        add(GpsPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: true));
        break;
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
        add(GpsPermissionEvent(
            isGpsEnabled: state.isGpsEnabled, isGpsPermissionGranted: false));
        openAppSettings();
    }
  }

  @override
  Future<void> close() {
    // limpiar serviceState stream
    gpsServiceSubscription
        ?.cancel(); //si tiene un valor entonces ejecuta cancel
    return super.close();
  }
}
