import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth_service/auth_service.dart';


class UserService {
  static const String _baseUrl = 'http://10.0.2.2:8080'; // O IP local si usas físico

  static Future<Map<String, dynamic>> getUserDashboardData(String userId) async {
    final authService = AuthService();
    final token = await authService.getToken();

    if (token == null) {
      throw Exception('Token no encontrado. El usuario no ha iniciado sesión.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/api/users/$userId/dashboard'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Error al cargar datos del dashboard');
  }
}
