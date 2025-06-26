import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/usuario/user_model.dart';

class AuthService {
  // Cambia esta URL según tu entorno (emulador o dispositivo físico)
  final String baseUrl = 'http://10.0.2.2:8080/api/usuarios';
  // Para físico: 'http://192.168.X.X:8080/api/usuarios';

  // Almacenamiento seguro para el token JWT
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  static const String _tokenKey = 'token';

  /// Iniciar sesión
  Future<User> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final userJson = body['usuario'];
        final token = body['token'];

        // ✅ Guardar el token JWT
        await _secureStorage.write(key: _tokenKey, value: token);

        return User(
          id: userJson['id'].toString(),
          nombre: userJson['nombre'] ?? 'Usuario',
          email: userJson['email'],
          rol: userJson['rol'] == 'ADMIN'
              ? UserRole.administrador
              : UserRole.turista,
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

  /// Registrar nuevo usuario
  Future<User> register(
    String nombre,
    String apellido,
    String email,
    String password,
    UserRole rol,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/register');

      final rolBackend = rol == UserRole.administrador ? 'ADMIN' : 'USER';

      final requestBody = {
        'nombre': nombre,
        'apellidos': apellido,
        'email': email,
        'password': password,
        'rol': rolBackend,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final usuario = data['usuario'];
        final token = data['token'];

        // ✅ Guardar token
        await _secureStorage.write(key: _tokenKey, value: token);

        return User(
          id: usuario['id'].toString(),
          nombre: usuario['nombre'] ?? 'Usuario',
          email: usuario['email'],
          rol: usuario['rol'] == 'ADMIN'
              ? UserRole.administrador
              : UserRole.turista,
        );
      } else {
        throw Exception(data['error'] ?? 'Error al registrar usuario');
      }
    } catch (e) {
      print('Error en register: $e');
      rethrow;
    }
  }

  /// Obtener el token JWT
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  /// Cerrar sesión
  Future<void> logout() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  /// Verificar si el usuario está autenticado
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

  /// Obtener usuario decodificando el token (opcional, si el token contiene info)
  /// Puedes implementar si necesitas acceder al rol sin volver a consultar el backend.
}
