import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/servicio/servicio_model.dart';

class ServicioService {
  final String _baseUrl = 'http://10.0.2.2:8080/api/servicios';

  Future<List<Servicio>> getAllServicios() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Servicio.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener servicios');
    }
  }

  Future<Servicio> createServicio(Servicio servicio) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(servicio.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      return Servicio.fromJson(data);
    } else {
      throw Exception('Error al crear el servicio');
    }
  }

  Future<void> deleteServicio(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el servicio');
    }
  }

  Future<Servicio> updateServicio(Servicio servicio) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/${servicio.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(servicio.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Servicio.fromJson(data);
    } else {
      throw Exception('Error al actualizar el servicio');
    }
  }
}
