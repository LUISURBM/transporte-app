
import 'package:cloud_firestore/cloud_firestore.dart';

class Conductor {
  const Conductor({
    required this.cedula,
    required this.nombres,
    required this.nacimiento,
    required this.email,
    required this.celular,
    required this.sexo
  }) : assert(cedula != null, nombres != null);

  factory Conductor.fromJson(dynamic json) {
    return Conductor(cedula: json['cedula'], nombres: json['nombres'], nacimiento: json['nacimiento'], sexo: json['sexo'], email: json['email'], celular: json['celular']);
  }

  final String cedula;
  final String nombres;
  final Timestamp nacimiento;
  final String email;
  final String celular;
  final String sexo;

  Map<String, dynamic> toJson() {
    return {
      'cedula': cedula,
      'nombres': nombres,
    };
  }

  @override
  int get hashCode => cedula.hashCode ^ nombres.hashCode;

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) || other is Conductor && cedula == other.cedula && nombres == other.nombres;
}