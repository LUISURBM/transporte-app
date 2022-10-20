import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transporte_app/model/conductor.dart';
import 'package:transporte_app/model/recorrido.dart';
import 'package:transporte_app/model/ruta.dart';

class DatabaseService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Create an instance of Firebase Firestore.

  Stream get allConductores => _firestore
      .collection("conductores")
      .snapshots(); // a stream that is continuously listening for changes happening in the database

  Future<String?> addUser(
      {required String fullName,
      required DateTime nacimiento,
      required String email,
      required String celular,
      required String cedula,
      required String sexo}) async {
    try {
      CollectionReference conductores = _firestore.collection('conductores');
      // Call the user's CollectionReference to add a new user
      await conductores.doc(email).set({
        'nombres': fullName,
        'nacimiento': nacimiento,
        'email': email,
        'celular': celular,
        'cedula': cedula,
        'sexo': sexo
      });
      return 'success';
    } catch (e) {
      return 'Error adding user';
    }
  }

  Future<String?> getUser(String cedula) async {
    try {
      CollectionReference conductores = _firestore.collection('conductores');
      final snapshot = await conductores.doc(cedula).get();
      final data = snapshot.data() as Map<String, dynamic>;
      return data['full_name'];
    } catch (e) {
      return 'Error fetching user';
    }
  }

  Future<List<Conductor>> getConductores() async {
    try {
      CollectionReference conductores = _firestore.collection('conductores');
      final snapshot = await conductores.doc().get();
      final data = snapshot.data() as List<Conductor>;
      return data;
    } catch (e) {
      return Future.value(null);
    }
  }

  Future<List<Recorrido>> getRoutesUser(String cedula) async {
    try {
      DocumentReference<Map<String, dynamic>> conductor =
          _firestore.collection('conductores').doc(cedula);
      CollectionReference rutas = _firestore.collection('rutas');
      final snapshot =
          await rutas.where('conductor', isEqualTo: conductor).get();
      List<Recorrido> resultado = [];
      for (var doc in snapshot.docs) {
        Ruta ruta = Ruta.fromJson(doc);
        resultado.add(Recorrido(
            info: ruta, ruta: (await ruta.toPolylines()), marcador: ruta.toMarker()));
      }
      return resultado;
    } catch (e) {
      return List.empty();
    }
  }
}

final databaseProvider = Provider((ref) => DatabaseService());
