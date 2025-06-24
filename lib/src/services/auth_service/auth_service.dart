import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/usuario/user_model.dart';

class AuthService {
  final String baseUrl = 'http://10.0.2.2:8080/api/usuarios';
  // Para dispositivo físico usa: 'http://192.168.0.110:8080/api/usuarios';

  Future<User> login(String email, String password) async {
    try {
      print('Intentando login con URL: $baseUrl/login');

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Login - Status Code: ${response.statusCode}');
      print('Login - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final userJson = body['usuario'];

        return User(
          id: userJson['id'].toString(),
          nombre: userJson['nombre'] ?? 'Usuario',
          email: userJson['email'],
          rol: userJson['rol'] == 'ADMIN' ? UserRole.administrador : UserRole.turista,
        );
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['error'] ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      print('Error en login: $e');
      rethrow;
    }
  }

  Future<User> register(String nombre, String apellido, String email, String password, UserRole rol) async {
    try {
      final url = Uri.parse('$baseUrl/register');

      // Mapear el rol correctamente según tu backend
      String rolBackend;
      switch (rol) {
        case UserRole.administrador:
          rolBackend = 'ADMIN';
          break;
        case UserRole.turista:
          rolBackend = 'USER';
          break;
      }

      // IMPORTANTE: Usar "apellido" (singular) para que coincida con el setter
      final requestBody = {
        'nombre': nombre,
        'apellidos': apellido,  // ✅ Campo corregido
        'email': email,
        'password': password,
        'rol': rolBackend,
      };


      print('Intentando registro con URL: $url');
      print('Datos a enviar: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Register - Status Code: ${response.statusCode}');
      print('Register - Response Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final usuario = data['usuario'];
        return User(
          id: usuario['id'].toString(),
          nombre: usuario['nombre'] ?? 'Usuario',
          email: usuario['email'],
          rol: usuario['rol'] == 'ADMIN' ? UserRole.administrador : UserRole.turista,
        );
      } else {
        // El backend devuelve errores con la clave 'error'
        String errorMessage = data['error'] ?? 'Error al registrar usuario';
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error en register: $e');
      rethrow;
    }
  }
}