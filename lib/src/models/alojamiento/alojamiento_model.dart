import 'package:equatable/equatable.dart';
import './categoria_alojamiento_model.dart';
import './direccion_model.dart';
import './foto_alojamiento_model.dart';
import './disponibilidad_model.dart';

class Alojamiento extends Equatable {
  final String id;
  final String nombre;
  final String descripcion;
  final double precioPorNoche;
  final String anfitrionId;
  final CategoriaAlojamiento categoria;
  final Direccion direccion;
  final List<FotoAlojamiento> fotos;
  final List<String> idServicios;
  final List<PeriodoDisponibilidad> periodosDisponibilidad;
  final double? calificacionPromedio;

  const Alojamiento({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precioPorNoche,
    required this.anfitrionId,
    required this.categoria,
    required this.direccion,
    this.fotos = const [],
    this.idServicios = const [],
    this.periodosDisponibilidad = const [],
    this.calificacionPromedio,
  });

  factory Alojamiento.fromJson(Map<String, dynamic> json) {
    return Alojamiento(
      id: json['id'].toString(),
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precioPorNoche: (json['precioPorNoche'] is int)
          ? (json['precioPorNoche'] as int).toDouble()
          : (json['precioPorNoche'] ?? 0.0),
      anfitrionId: json['anfitrionId'] ?? '',
      categoria: CategoriaAlojamiento.fromJson(json['categoria']),
      direccion: Direccion.fromJson(json['direccion']),
      fotos: (json['fotos'] as List<dynamic>?)
              ?.map((f) => FotoAlojamiento.fromJson(f))
              .toList() ??
          [],
      idServicios: (json['idServicios'] as List<dynamic>?)
              ?.map((id) => id.toString())
              .toList() ??
          [],
      periodosDisponibilidad:
          (json['periodosDisponibilidad'] as List<dynamic>?)
                  ?.map((p) => PeriodoDisponibilidad.fromJson(p))
                  .toList() ??
              [],
      calificacionPromedio: json['calificacionPromedio'] != null
          ? double.tryParse(json['calificacionPromedio'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        descripcion,
        precioPorNoche,
        anfitrionId,
        categoria,
        direccion,
        fotos,
        idServicios,
        periodosDisponibilidad,
        calificacionPromedio,
      ];
}
