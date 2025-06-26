import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateServicioScreen extends StatefulWidget {
  const CreateServicioScreen({Key? key}) : super(key: key);

  @override
  State<CreateServicioScreen> createState() => _CreateServicioScreenState();
}

class _CreateServicioScreenState extends State<CreateServicioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();

  String _categoria = 'CULTURAL'; // ejemplo inicial
  String _icono = '🎯'; // ejemplo simple, puedes reemplazar con picker
  bool _activo = true;

  final _secureStorage = const FlutterSecureStorage();

  Future<void> _guardarServicio() async {
    if (_formKey.currentState!.validate()) {
      final token = await _secureStorage.read(key: 'token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Token no disponible. Inicie sesión.'),
          backgroundColor: Colors.red,
        ));
        return;
      }

      final servicioData = {
        'nombre': _nombreController.text,
        'descripcion': _descripcionController.text,
        'categoria': _categoria,
        'icono': _icono,
        'activo': _activo,
      };

      try {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8080/api/servicios'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(servicioData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Servicio creado exitosamente'),
            backgroundColor: Colors.green,
          ));
          Navigator.pop(context);
        } else {
          print('Respuesta: ${response.body}');
          throw Exception('Error al crear el servicio');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Servicio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: ['CULTURAL', 'BASICO', 'FAMILIAR', 'ENTRETENIMIENTO', 'ACCESIBILIDAD']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _categoria = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _icono,
                decoration: const InputDecoration(labelText: 'Ícono'),
                onChanged: (value) => _icono = value,
              ),
              SwitchListTile(
                title: const Text('Activo'),
                value: _activo,
                onChanged: (val) => setState(() => _activo = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _guardarServicio,
                child: const Text('Crear Servicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
