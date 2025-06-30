import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:turismo_capachica/src/blocs/reserva_bloc/reserva_bloc.dart';
import 'package:turismo_capachica/src/screens/admin/admin_dashboard_screen.dart';
import 'package:turismo_capachica/src/screens/admin/manage_alojamientos_screen.dart';
import 'package:turismo_capachica/src/screens/admin/manage_servicios_screen.dart';
import 'package:turismo_capachica/src/screens/alojamientos/alojamiento_detail_screen.dart';
import 'package:turismo_capachica/src/screens/alojamientos/alojamiento_list_screen.dart';
import 'package:turismo_capachica/src/screens/admin/create_alojamiento_screen.dart';
import 'package:turismo_capachica/src/screens/admin/create_servicio_screen.dart';
import 'package:turismo_capachica/src/screens/auth/login_screen.dart';
import 'package:turismo_capachica/src/screens/auth/register_screen.dart';
import 'package:turismo_capachica/src/screens/home/home_screen.dart';
import 'package:turismo_capachica/src/screens/reservas/create_reserva_screen.dart';
import 'package:turismo_capachica/src/screens/reservas/user_reservas_screen.dart';
import 'package:turismo_capachica/src/screens/usuario/user_dashboard_screen.dart';
import 'package:turismo_capachica/src/screens/mapa/mapa_screen.dart'; // ✅ Importación agregada
import 'package:turismo_capachica/src/services/reserva_service/reserva_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReservaBloc>(
          create: (context) => ReservaBloc(ReservaService()),
        ),
        // Puedes agregar más BlocProviders aquí si tienes otros blocs
      ],
      child: MaterialApp(
        title: 'Turismo Capachica',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/home',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/admin/dashboard': (context) => const AdminDashboardScreen(),
          '/admin/manage-alojamientos': (context) => const ManageAlojamientosScreen(),
          '/admin/manage-servicios': (context) => const ManageServiciosScreen(),
          '/admin/create-alojamiento': (context) => const CreateAlojamientoScreen(),
          '/admin/create-servicio': (context) => const CreateServicioScreen(),
          '/alojamientos/detail': (context) {
            final id = ModalRoute.of(context)!.settings.arguments as String?;
            return AlojamientoDetailScreen(alojamientoId: id ?? '1');
          },
          '/alojamientos/list': (context) => const AlojamientoListScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/reservas/create': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
            return CreateReservaScreen(
              alojamientoData: args ?? {'id': '1', 'nombre': 'Default', 'precioPorNoche': 100.0},
            );
          },
          '/reservas/user': (context) => const UserReservasScreen(),
          '/admin-dashboard': (context) => const AdminDashboardScreen(),
          '/user-dashboard': (context) => const UserDashboardScreen(),
          '/manage-alojamientos': (context) => const ManageAlojamientosScreen(),
          '/manage-servicios': (context) => const ManageServiciosScreen(),
          '/mapa': (context) => const MapaScreen(),
        },
      ),
    );
  }
}
