import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/reserva/reserva_model.dart';

class ReservaService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/reservas';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<Reserva> createReserva({
    required String alojamientoId,
    required String usuarioId,
    required DateTime fechaInicio,
    required DateTime fechaFin,
    required int numeroHuespedes,
    required double costoTotal,
    String? notasEspeciales,
  }) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('Token JWT no encontrado. El usuario no está autenticado.');
    }

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "usuario": {"id": int.parse(usuarioId)},
        "alojamiento": {"id": int.parse(alojamientoId)},
        "fechaInicio": fechaInicio.toIso8601String(),
        "fechaFin": fechaFin.toIso8601String(),
        "numHuespedes": numeroHuespedes,
        "precioNoche": (costoTotal / numeroHuespedes).toStringAsFixed(2), // estimado
        "precioLimpieza": 0,
        "precioServicio": 0,
        "precioTotal": costoTotal,
        "notasEspeciales": notasEspeciales ?? ""
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);

      return Reserva(
        id: json['id'].toString(),
        alojamientoId: json['alojamiento']['id'].toString(),
        usuarioId: json['usuario']['id'].toString(),
        fechaInicio: DateTime.parse(json['fechaInicio']),
        fechaFin: DateTime.parse(json['fechaFin']),
        numeroHuespedes: json['numHuespedes'],
        costoTotal: double.parse(json['precioTotal'].toString()),
        estado: EstadoReserva.values.firstWhere(
          (e) => e.name.toLowerCase() == json['estado'].toString().toLowerCase(),
          orElse: () => EstadoReserva.pendiente,
        ),
        fechaCreacion: DateTime.parse(json['createdAt']),
        notasEspeciales: json['notasEspeciales'],
      );
    } else {
      print("ERROR al crear reserva: ${response.statusCode}");
      print("CUERPO: ${response.body}");
      throw Exception('Error al crear reserva. Código: ${response.statusCode}');
    }
  }
}
