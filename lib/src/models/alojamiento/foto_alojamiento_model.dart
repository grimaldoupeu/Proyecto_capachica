import 'package:equatable/equatable.dart';

class FotoAlojamiento extends Equatable {
  final String id;
  final String alojamientoId; // Foreign key to Alojamiento
  final String urlFoto;
  final String? descripcion; // Optional caption for the photo

  const FotoAlojamiento({
    required this.id,
    required this.alojamientoId,
    required this.urlFoto,
    this.descripcion,
  });
  factory FotoAlojamiento.fromJson(Map<String, dynamic> json) {
    return FotoAlojamiento(
      id: json['id'],
      alojamientoId: json['alojamientoId'],
      urlFoto: json['urlFoto'],
      descripcion: json['descripcion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alojamientoId': alojamientoId,
      'urlFoto': urlFoto,
      'descripcion': descripcion,
    };
  }


  @override
  List<Object?> get props => [id, alojamientoId, urlFoto, descripcion];
}
