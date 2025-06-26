import 'package:equatable/equatable.dart';

class CategoriaAlojamiento extends Equatable {
  final String id;
  final String nombre;
  // final String? descripcion; // Optional

  const CategoriaAlojamiento({
    required this.id,
    required this.nombre,
    // this.descripcion,
  });
  factory CategoriaAlojamiento.fromJson(Map<String, dynamic> json) {
    return CategoriaAlojamiento(
      id: json['id'],
      nombre: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
    };
  }


  @override
  List<Object?> get props => [id, nombre];
}
