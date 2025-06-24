import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Cambia esta URL por la IP de tu backend
  static const String baseUrl = 'http://112.138.0.100:8080/api';
  // Para dispositivo físico usa: 'http://TU_IP:8080/api'
  // Para emulador Android usa: 'http://10.0.2.2:8080/api'

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Obtener todos los alojamientos
  static Future<List<dynamic>> getAllAlojamientos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alojamientoservicios'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al cargar alojamientos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Obtener alojamiento por ID
  static Future<Map<String, dynamic>> getAlojamientoById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/alojamientoservicios/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al cargar alojamiento: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Crear nuevo alojamiento
  static Future<Map<String, dynamic>> createAlojamiento(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/alojamientoservicios'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al crear alojamiento: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // Actualizar alojamiento
  static Future<Map<String, dynamic>> updateAlojamiento(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/alojamientoservicios/$id'),
        headers: headers,
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al actualizar alojamiento: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}