import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/alojamiento/alojamiento_model.dart';
import '../../models/alojamiento/categoria_alojamiento_model.dart';
import '../../models/alojamiento/direccion_model.dart';
import '../../models/alojamiento/foto_alojamiento_model.dart';

class AlojamientoService {
  final String _baseUrl = 'http://112.138.0.100:8080/api/alojamientos';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _secureStorage.read(key: 'token'); // usa misma clave que en AuthService
  }

  Future<Alojamiento> createAlojamiento(Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No se encontró un token de autenticación. Por favor, inicia sesión.');
    }

    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Alojamiento.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear alojamiento: ${response.body}');
    }
  }

  Future<Alojamiento> updateAlojamiento(String id, Map<String, dynamic> data) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token no encontrado.');

    final response = await http.put(
      Uri.parse('$_baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return Alojamiento.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar alojamiento: ${response.body}');
    }
  }

  Future<void> deleteAlojamiento(String id) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token no encontrado.');

    final response = await http.delete(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Error al eliminar alojamiento: ${response.body}');
    }
  }

  Future<List<Alojamiento>> getAllAlojamientos() async {
    final token = await _getToken();
    if (token == null) throw Exception('Token no encontrado.');

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Alojamiento.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener alojamientos: ${response.body}');
    }
  }

  Future<Alojamiento> getAlojamientoById(String id) async {
    final token = await _getToken();
    if (token == null) throw Exception('Token no encontrado.');

    final response = await http.get(
      Uri.parse('$_baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return Alojamiento.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al obtener alojamiento: ${response.body}');
    }
  }
}
