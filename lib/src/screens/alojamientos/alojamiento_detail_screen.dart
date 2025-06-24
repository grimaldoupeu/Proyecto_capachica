import 'package:flutter/material.dart';

class AlojamientoDetailScreen extends StatelessWidget {
  final String alojamientoId;

  const AlojamientoDetailScreen({super.key, required this.alojamientoId});

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
    final alojamientoData = _getAlojamientoData(alojamientoId);
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
              background: PageView.builder(
                itemCount: (alojamientoData['fotos'] as List).length,
                itemBuilder: (context, index) {
                  return Image.network(
                    (alojamientoData['fotos'] as List)[index]['urlFoto'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 100),
                    ),
                  );
                },
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
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.map, size: 48, color: Colors.grey),
                            Text('Mapa de ubicación'),
                            Text('(Próximamente)', style: TextStyle(fontSize: 12)),
                          ],
                        ),
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