part of 'gps_bloc.dart';

class GpsState extends Equatable {
  final bool isGpsEnabled; //esta habililitado el GPS?
  final bool isGpsPermissionGranted; //cedimos permiso para usar el GPS?

  ///uso este get que me va a permitir cambiar de pantalla en caso que isGpsEnabled
  ///y isGpsPermissionGranted sean true
  bool get isAllgranted => isGpsEnabled && isGpsPermissionGranted;

// Como estas propiedades son las que van a determinar si un Estado es igual a otro, es decir, si el
// GPS está en true y el permiso está en true también. Y después si emito otro evento que también me disparó un
//estado que ambas propiedades son iguales a true. Entonces realmente no es un nuevo estado, ES EL MISMO ESTADO
// y eso va a determinar BLOC cuando va a ser un nuevo estado y  redibujar o no, pero si yo lo dejo así cada vez
//que crea una nueva instancia de mi GPS State siempre va a ser una instancia nueva, por lo cual aquí es conveniente
//que esas propiedades las coloquemos en este override que es el que no se extiende o nos permite trabajarlo con
//el equatable. Entonces, estas son las propiedades que me van a ayudar a mí a determinar si un estado es igual a otro.

  const GpsState(
      {required this.isGpsEnabled, required this.isGpsPermissionGranted});

  @override
  List<Object> get props => [isGpsEnabled, isGpsPermissionGranted];

  ///sobreescribo el metodo toString para mostrar la info de mi estado en consola
  @override
  String toString() =>
      '{isGpsEnabled: $isGpsEnabled, isGpsPermissionGranted: $isGpsPermissionGranted}';

//uso metodo para copia el estado, copia la instancia de GpsState con los nuevos valores o si no se pasan
// con los de la instancia de GpsState original.
  GpsState copyWith({
    bool? isGpsEnabled,
    bool? isGpsPermissionGranted,
  }) =>
      GpsState(
          isGpsEnabled: isGpsEnabled ?? this.isGpsEnabled,
          isGpsPermissionGranted:
              isGpsPermissionGranted ?? this.isGpsPermissionGranted);
}
