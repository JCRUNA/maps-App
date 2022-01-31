import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? positionStream;
  LocationBloc() : super(const LocationState()) {
    on<OnStartFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(followingUser: true)));

    on<OnStopFollowingUserEvent>(
        (event, emit) => emit(state.copyWith(followingUser: false)));

    on<OnNewUserLocationEvent>((event, emit) {
      emit(state.copyWith(
          lastKnownLocation: event.newLocation,
          myLocationHistory: [...state.myLocationHistory, event.newLocation]));
    });
  }

  ///obtener la posicion actual
  Future getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition();
    print('Position: $position');
  }

  ///seguir al usuario con una stream. RECORDAR SIEMPRE HAY QUE LIMPIAR LA SUBSCRIPCION!!
  ///Para eso primero arriba debemos definir la suscribcion StreamSubscription<Position>? positionStream;
  void startFollowingUser() {
    add(OnStartFollowingUserEvent());
    print('star following user');
    positionStream = Geolocator.getPositionStream().listen((event) {
      ///event es de tipo position
      final position = event;
      print('Posicion: $position');
      add(OnNewUserLocationEvent(
          LatLng(position.latitude, position.longitude)));
    });
  }

  void stopFollowingUser() {
    positionStream?.cancel();
    print('stop following');
    add(OnStopFollowingUserEvent());
  }

  @override
  Future<void> close() {
    // RECORDAR SIEMPRE HAY QUE LIMPIAR LA SUBSCRIPCION!!
    stopFollowingUser();
    return super.close();
  }
}
