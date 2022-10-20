import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transporte_app/model/ruta.dart';

class Recorrido {
  const Recorrido({required this.marcador, required this.ruta, required this.info})
      : assert(marcador != null, ruta != null);
  final List<Marker> marcador;
  final Polyline ruta;
  final Ruta info;

  @override
  int get hashCode => marcador.hashCode ^ ruta.hashCode ^ info.hashCode;

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      other is Recorrido && marcador == other.marcador && ruta == other.ruta && info == other.info;
}
