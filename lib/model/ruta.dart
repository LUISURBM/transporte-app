import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ruta {
  const Ruta(
      {required this.duracion,
      required this.nombre,
      required this.inicio,
      required this.finalizacion,
      required this.latitud,
      required this.longitud,
      required this.latitud_fin,
      required this.longitud_fin,
      required this.observaciones})
      : assert(duracion != null, nombre != null);

  factory Ruta.fromJson(dynamic json) {
    return Ruta(
        duracion: json['duracion'],
        nombre: json['nombre'],
        inicio: json['inicio'],
        finalizacion: json['finalizacion'],
        longitud: json['longitud'],
        latitud: json['latitud'],
        longitud_fin: json['longitud_fin'],
        latitud_fin: json['latitud_fin'],
        observaciones: json['observaciones']);
  }

  List<Marker> toMarker() {
    return [
      Marker(
        //add second marker
        markerId: MarkerId(nombre),
        position: LatLng(latitud, longitud), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: nombre,
          snippet: observaciones,
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ),
      Marker(
        //add second marker
        markerId: MarkerId(nombre),
        position: LatLng(latitud_fin, longitud_fin), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: nombre,
          snippet: observaciones,
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      )
    ];
  }

  Future<Polyline> toPolylines() async {
    List<LatLng> route = [];
    LatLng origin = LatLng(latitud, longitud);
    LatLng end = LatLng(latitud_fin, longitud_fin);
    List<LatLng> latLen = [origin, end];
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      'AIzaSyCxe1Cmd2AnlO8SIEQt12IXt_G8DZ2xegg',
      PointLatLng(latitud, longitud),
      PointLatLng(latitud_fin, longitud_fin),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        route.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      route.add(LatLng(latitud, longitud));
      route.add(LatLng(latitud_fin, longitud_fin));
    }
    return Polyline(
      polylineId: PolylineId(nombre),
      points: route,
      color: Colors.green,
    );
  }

  Future<Polyline> toPolygon() async {
    List<LatLng> route = [];
    LatLng origin = LatLng(latitud, longitud);
    LatLng end = LatLng(latitud_fin, longitud_fin);
    List<LatLng> latLen = [origin, end];
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      'AIzaSyCxe1Cmd2AnlO8SIEQt12IXt_G8DZ2xegg',
      PointLatLng(latitud, longitud),
      PointLatLng(latitud_fin, longitud_fin),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        route.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      route.add(LatLng(latitud, longitud));
      route.add(LatLng(latitud_fin, longitud_fin));
    }
    return Polyline(
      polylineId: const PolylineId('1'),
      points: latLen,
      color: Colors.green,
    );
  }

  final int duracion;
  final String nombre;
  final String observaciones;
  final Timestamp inicio;
  final Timestamp finalizacion;
  final double latitud;
  final double longitud;
  final double latitud_fin;
  final double longitud_fin;

  Map<String, dynamic> toJson() {
    return {
      'duracion': duracion,
      'nombre': nombre,
    };
  }

  @override
  int get hashCode => duracion.hashCode ^ nombre.hashCode;

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      other is Ruta && duracion == other.duracion && nombre == other.nombre;
}
