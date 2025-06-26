import 'package:flutter/material.dart';
import '../../services/alojamiento_service/alojamiento_service.dart';

class CreateAlojamientoScreen extends StatefulWidget {
  const CreateAlojamientoScreen({Key? key}) : super(key: key);

  @override
  State<CreateAlojamientoScreen> createState() => _CreateAlojamientoScreenState();
}

class _CreateAlojamientoScreenState extends State<CreateAlojamientoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _precioController = TextEditingController();
  final _capacidadController = TextEditingController();
  final _numHabitacionesController = TextEditingController();
  final _numCamasController = TextEditingController();
  final _numBanosController = TextEditingController();
  final _departamentoController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _distritoController = TextEditingController();

  String _tipoAlojamiento = 'Hotel'; // Cambiado de final a variable mutable
  List<String> _servicios = [];
  bool _wifiGratis = false; // Cambiado de final a variable mutable
  bool _desayunoIncluido = false; // Cambiado de final a variable mutable
  bool _estacionamiento = false; // Cambiado de final a variable mutable
  bool _piscina = false; // Cambiado de final a variable mutable
  bool _gimnasio = false; // Cambiado de final a variable mutable
  bool _aireAcondicionado = false; // Cambiado de final a variable mutable
  bool _isLoading = false;

  final AlojamientoService _alojamientoService = AlojamientoService();

  final List<String> _tiposAlojamiento = [
    'Hotel',
    'Hostal',
    'Casa Rural',
    'Apartamento',
    'Cabaña',
    'Lodge',
    'Pensión'
  ];

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _direccionController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _precioController.dispose();
    _capacidadController.dispose();
    _numHabitacionesController.dispose();
    _numCamasController.dispose();
    _numBanosController.dispose();
    _departamentoController.dispose();
    _provinciaController.dispose();
    _distritoController.dispose();
    super.dispose();
  }

  void _updateServicios() {
    _servicios.clear();
    if (_wifiGratis) _servicios.add('WiFi Gratis');
    if (_desayunoIncluido) _servicios.add('Desayuno Incluido');
    if (_estacionamiento) _servicios.add('Estacionamiento');
    if (_piscina) _servicios.add('Piscina');
    if (_gimnasio) _servicios.add('Gimnasio');
    if (_aireAcondicionado) _servicios.add('Aire Acondicionado');
  }

  Future<void> _guardarAlojamiento() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      _updateServicios();

      try {
        // Mejor manejo del precio
        String precioTexto = _precioController.text.trim();
        if (precioTexto.isEmpty) {
          throw FormatException('El precio no puede estar vacío');
        }

        // Reemplazar comas por puntos y eliminar espacios
        precioTexto = precioTexto.replaceAll(',', '.').replaceAll(' ', '');

        final precio = double.tryParse(precioTexto);
        if (precio == null || precio <= 0) {
          throw FormatException('El precio debe ser un número válido mayor a 0');
        }

        final capacidadTexto = _capacidadController.text.trim();
        if (capacidadTexto.isEmpty) {
          throw FormatException('La capacidad no puede estar vacía');
        }

        final capacidad = int.tryParse(capacidadTexto);
        if (capacidad == null || capacidad <= 0) {
          throw FormatException('La capacidad debe ser un número entero mayor a 0');
        }

        final alojamientoData = {
          'titulo': _nombreController.text.trim(), // nombre -> titulo
          'nombre': _nombreController.text.trim(), // mantener nombre también
          'descripcion': _descripcionController.text.trim(),
          'direccion': _direccionController.text.trim(),
          'tipo_propiedad': _tipoAlojamiento, // tipo -> tipo_propiedad
          'max_huespedes': capacidad, // capacidad -> max_huespedes
          'precio_noche': precio, // precioPorNoche -> precio_noche

          // Campos requeridos con valores por defecto
          'anfitrion_id': 1, // O el ID real del usuario logueado
          'emprendedor_id': 1, // Si es necesario
          'categoria_id': 1, // Asignar una categoría por defecto

          // Campos de ubicación
          'departamento': _departamentoController.text.trim().isNotEmpty
              ? _departamentoController.text.trim() : 'Por definir',
          'provincia': _provinciaController.text.trim().isNotEmpty
              ? _provinciaController.text.trim() : 'Por definir',
          'distrito': _distritoController.text.trim().isNotEmpty
              ? _distritoController.text.trim() : 'Por definir',
          'comunidad': _direccionController.text.trim(),

          // Campos numéricos del formulario
          'num_habitaciones': int.tryParse(_numHabitacionesController.text) ?? 1,
          'num_camas': int.tryParse(_numCamasController.text) ?? 1,
          'num_banos': int.tryParse(_numBanosController.text) ?? 1,
          'precio_limpieza': 0.0,
          'precio_servicio': 0.0,

          // Campos de tiempo con valores por defecto
          'checkin_desde': '14:00',
          'checkin_hasta': '20:00',
          'checkout_hasta': '11:00',
          'estancia_minima': 1,
          'estancia_maxima': 30,

          // Políticas por defecto
          'politica_cancelacion': 'Flexible',
          'permite_mascotas': false,
          'permite_ninos': true,

          // Estados por defecto
          'activo': true,
          'verificado': false,
          'disponible': true,

          // Descuentos opcionales
          'descuento_semanal': 0.0,
          'descuento_mensual': 0.0,

          // Timestamps se manejan automáticamente en la BD
        };

        // Debug: Imprimir los datos que se van a enviar
        print('Datos a enviar: $alojamientoData');

        await _alojamientoService.createAlojamiento(alojamientoData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Alojamiento creado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pop(context);
        }
      } catch (e) {
        // Debug: Imprimir error completo en consola
        print('Error completo: $e');
        print('Tipo de error: ${e.runtimeType}');

        String errorMessage;
        if (e is FormatException) {
          errorMessage = e.message;
        } else if (e is Exception) {
          errorMessage = e.toString().replaceAll('Exception: ', '');
        } else {
          errorMessage = 'Error desconocido: $e';
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $errorMessage'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Alojamiento'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Alojamiento',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese el nombre del alojamiento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Descripción
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese una descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Dirección
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(
                  labelText: 'Dirección',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese la dirección';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Teléfono
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese el teléfono';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese el email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Por favor ingrese un email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Precio
              TextFormField(
                controller: _precioController,
                decoration: const InputDecoration(
                  labelText: 'Precio por Noche',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  final precio = double.tryParse(value.replaceAll(',', '.'));
                  if (precio == null || precio <= 0) {
                    return 'Por favor ingrese un precio válido mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Capacidad
              TextFormField(
                controller: _capacidadController,
                decoration: const InputDecoration(
                  labelText: 'Capacidad (personas)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingrese la capacidad';
                  }
                  final capacidad = int.tryParse(value);
                  if (capacidad == null || capacidad <= 0) {
                    return 'Por favor ingrese una capacidad válida mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campos de ubicación
              const Text(
                'Ubicación',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              TextFormField(
                controller: _departamentoController,
                decoration: const InputDecoration(
                  labelText: 'Departamento',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _provinciaController,
                decoration: const InputDecoration(
                  labelText: 'Provincia',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _distritoController,
                decoration: const InputDecoration(
                  labelText: 'Distrito',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Características de la propiedad
              const Text(
                'Características',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numHabitacionesController,
                      decoration: const InputDecoration(
                        labelText: 'Habitaciones',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final num = int.tryParse(value);
                          if (num == null || num <= 0) {
                            return 'Número inválido';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _numCamasController,
                      decoration: const InputDecoration(
                        labelText: 'Camas',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final num = int.tryParse(value);
                          if (num == null || num <= 0) {
                            return 'Número inválido';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _numBanosController,
                      decoration: const InputDecoration(
                        labelText: 'Baños',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final num = int.tryParse(value);
                          if (num == null || num <= 0) {
                            return 'Número inválido';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dropdown Tipo de Alojamiento
              DropdownButtonFormField<String>(
                value: _tipoAlojamiento,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Propiedad',
                  border: OutlineInputBorder(),
                ),
                items: _tiposAlojamiento.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _tipoAlojamiento = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Servicios
              const Text(
                'Servicios',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              CheckboxListTile(
                title: const Text('WiFi Gratis'),
                value: _wifiGratis,
                onChanged: (bool? value) {
                  setState(() {
                    _wifiGratis = value ?? false;
                  });
                },
              ),

              CheckboxListTile(
                title: const Text('Desayuno Incluido'),
                value: _desayunoIncluido,
                onChanged: (bool? value) {
                  setState(() {
                    _desayunoIncluido = value ?? false;
                  });
                },
              ),

              CheckboxListTile(
                title: const Text('Estacionamiento'),
                value: _estacionamiento,
                onChanged: (bool? value) {
                  setState(() {
                    _estacionamiento = value ?? false;
                  });
                },
              ),

              CheckboxListTile(
                title: const Text('Piscina'),
                value: _piscina,
                onChanged: (bool? value) {
                  setState(() {
                    _piscina = value ?? false;
                  });
                },
              ),

              CheckboxListTile(
                title: const Text('Gimnasio'),
                value: _gimnasio,
                onChanged: (bool? value) {
                  setState(() {
                    _gimnasio = value ?? false;
                  });
                },
              ),

              CheckboxListTile(
                title: const Text('Aire Acondicionado'),
                value: _aireAcondicionado,
                onChanged: (bool? value) {
                  setState(() {
                    _aireAcondicionado = value ?? false;
                  });
                },
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16)
                      ),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _guardarAlojamiento,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Crear Alojamiento'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}