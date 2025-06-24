import 'package:equatable/equatable.dart';

class Servicio extends Equatable {
  final String id;
  final String nombre;
  final String? descripcion;
  final String? icono;
  final String? categoria; // Puede ser enum si prefieres
  final bool activo;

  const Servicio({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.icono,
    this.categoria,
    this.activo = true, String? iconoUrlOrCode,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) {
    return Servicio(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      icono: json['icono'],
      categoria: json['categoria'],
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'icono': icono,
      'categoria': categoria,
      'activo': activo,
    };
  }

  @override
  List<Object?> get props => [id, nombre, descripcion, icono, categoria, activo];
}
