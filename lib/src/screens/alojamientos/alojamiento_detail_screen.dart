import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart'; // Necesitas agregar esta importación

class AlojamientoDetailScreen extends StatefulWidget {
  final String alojamientoId;

  const AlojamientoDetailScreen({super.key, required this.alojamientoId});

  @override
  State<AlojamientoDetailScreen> createState() => _AlojamientoDetailScreenState();
}

class _AlojamientoDetailScreenState extends State<AlojamientoDetailScreen> {
  late MapController _mapController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  // Función para obtener la ubicación del usuario
  Future<LatLng?> _getUserLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    // Verifica permisos
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    // Obtiene la ubicación actual
    final userLocation = await location.getLocation();
    return LatLng(userLocation.latitude!, userLocation.longitude!);
  }

  // Función para obtener datos del alojamiento basado en el ID
  Map<String, dynamic> _getAlojamientoData(String id) {
    // En una app real, esto vendría de tu base de datos/API
    final alojamientos = {
      '1': {
        'id': '1',
        'nombre': 'Cabaña del Sol',
        'descripcion': 'Una hermosa cabaña con vista panorámica al lago Titicaca. Perfecta para descansar y disfrutar de la naturaleza en Capachica. Cuenta con todas las comodidades modernas manteniendo un estilo rústico y acogedor.',
        'precioPorNoche': 150.0,
        'ciudad': 'Capachica',
        'calificacionPromedio': 4.7,
        'numeroDeResenas': 32,
        'urlFoto': 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&h=250&fit=crop&crop=center',
        'anfitrion': {'nombre': 'Juan Pérez', 'avatarUrl': 'https://via.placeholder.com/50x50.png?text=JP'},
        'direccion': {'fullAddress': 'Principal S/N, Capachica, Puno, Perú', 'latitud': -15.65, 'longitud': -69.83},
        'fotos': [
          {'urlFoto': 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&h=250&fit=crop&crop=center'},
          {'urlFoto': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=250&fit=crop&crop=center'},
          {'urlFoto': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=250&fit=crop&crop=center'},
        ],
        'servicios': ['WiFi gratuito', 'Desayuno incluido', 'Cocina equipada', 'Estacionamiento gratuito', 'Vista al lago'],
        'disponibilidad': 'Disponible todo el año',
      },
      '2': {
        'id': '2',
        'nombre': 'Casa del Lago',
        'descripcion': 'Casa familiar ubicada a orillas del lago Titicaca. Ideal para grupos grandes y familias que buscan comodidad y tranquilidad.',
        'precioPorNoche': 120.0,
        'ciudad': 'Puno',
        'calificacionPromedio': 4.5,
        'numeroDeResenas': 25,
        'urlFoto': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=250&fit=crop&crop=center',
        'anfitrion': {'nombre': 'María García', 'avatarUrl': 'https://via.placeholder.com/50x50.png?text=MG'},
        'direccion': {'fullAddress': 'Jr. Lima 123, Puno, Perú', 'latitud': -15.84, 'longitud': -70.02},
        'fotos': [
          {'urlFoto': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=400&h=250&fit=crop&crop=center'},
          {'urlFoto': 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&h=250&fit=crop&crop=center'},
        ],
        'servicios': ['WiFi gratuito', 'Cocina completa', 'Jardín privado', 'Parrilla'],
        'disponibilidad': 'Disponible fines de semana',
      },
      // Agregar más alojamientos según sea necesario
    };

    return alojamientos[id] ?? alojamientos['1']!;
  }

  @override
  Widget build(BuildContext context) {
    final alojamientoData = _getAlojamientoData(widget.alojamientoId);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                alojamientoData['nombre'] as String,
                style: const TextStyle(
                  shadows: [
                    Shadow(
                      blurRadius: 3.0,
                      color: Colors.black54,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: (alojamientoData['fotos'] as List).length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        (alojamientoData['fotos'] as List)[index]['urlFoto'] as String,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Error loading image: $error');
                          return Container(
                            color: Colors.grey[300],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.broken_image, size: 64, color: Colors.grey),
                                const SizedBox(height: 8),
                                Text(
                                  'Error al cargar imagen',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Indicador de páginas
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1} / ${(alojamientoData['fotos'] as List).length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Agregado a favoritos')),
                  );
                },
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título y calificación
                    Text(
                      alojamientoData['nombre'] as String,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${alojamientoData['calificacionPromedio']} (${alojamientoData['numeroDeResenas']} reseñas)',
                          style: textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 8),
                        Text('·', style: textTheme.bodyLarge),
                        const SizedBox(width: 8),
                        Text(
                          alojamientoData['ciudad'] as String,
                          style: textTheme.bodyLarge?.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // Información del anfitrión
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            (alojamientoData['anfitrion'] as Map)['avatarUrl'] as String,
                          ),
                          onBackgroundImageError: (_, __) {},
                          child: const Icon(Icons.person),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alojado por ${(alojamientoData['anfitrion'] as Map)['nombre']}',
                              style: textTheme.titleMedium,
                            ),
                            Text(
                              'Superanfitrión · 3 años de experiencia',
                              style: textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(height: 32),

                    // Descripción
                    Text('Descripción', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      alojamientoData['descripcion'] as String,
                      style: textTheme.bodyMedium,
                    ),
                    const Divider(height: 32),

                    // Servicios
                    Text('Servicios ofrecidos', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: (alojamientoData['servicios'] as List<String>)
                          .map((servicio) => Chip(
                                label: Text(servicio),
                                backgroundColor: Colors.blue[50],
                              ))
                          .toList(),
                    ),
                    const Divider(height: 32),

                    // Ubicación
                    Text('Ubicación', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      (alojamientoData['direccion'] as Map<String, dynamic>)['fullAddress'] as String,
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: FutureBuilder<LatLng?>(
                      future: _getUserLocation(),
                      builder: (context, snapshot) {
                        final LatLng alojamientoLatLng = LatLng(
                          (alojamientoData['direccion'] as Map)['latitud'] as double,
                          (alojamientoData['direccion'] as Map)['longitud'] as double,
                        );

                        final LatLng? userLatLng = snapshot.data;

                        return Container(
                          height: 200,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: alojamientoLatLng,
                              initialZoom: 14,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiZ3JpbWFsZG9hcnJlZG9uZG8iLCJhIjoiY21hYmJvMGpoMmF6YjJrb29tNnJ0MXQ1dyJ9.Em9vVlsuF3-ddqRnxTMYAw',
                                userAgentPackageName: 'com.example.turismo_capachica',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: alojamientoLatLng,
                                    width: 40,
                                    height: 40,
                                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                                  ),
                                  if (userLatLng != null)
                                    Marker(
                                      point: userLatLng,
                                      width: 40,
                                      height: 40,
                                      child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                    const Divider(height: 32),

                    // Disponibilidad
                    Text('Disponibilidad', style: textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      alojamientoData['disponibilidad'] as String,
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calendario próximamente')),
                        );
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Ver fechas disponibles'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 80), // Espacio para la barra inferior
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'S/ ${(alojamientoData['precioPorNoche'] as double).toStringAsFixed(0)}',
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' /noche',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Impuestos incluidos',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navegar a la pantalla de crear reserva
                    Navigator.pushNamed(
                      context,
                      '/reservas/create',
                      arguments: alojamientoData,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Reservar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}