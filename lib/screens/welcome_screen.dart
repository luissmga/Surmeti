import 'package:flutter/material.dart';
import 'package:surmeti/screens/notificaciones_screen.dart';
import 'code_user_screen.dart'; // Asegúrate de importar la nueva pantalla
import '../theme/app_theme.dart';
import 'agregar_screen.dart';
import 'editar_screen.dart';
import 'ver_equipos_screen.dart';
import 'registro_mantenimiento_screen.dart';
import 'eliminar_screen.dart';
import 'registro_validacion_screen.dart';
import 'ayuda_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static Widget buildBox(BuildContext context, String title, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: 160,
        height: 110,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 0, 0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: AppTheme.boxTextStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Bienvenido',
            style: AppTheme.appBarTextStyle,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '¿Qué quieres hacer hoy?',
              style: AppTheme.subtitleTextStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildBox(context, 'Agregar', const AgregarScreen()),
                buildBox(context, 'Editar', const EditarScreen()),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildBox(context, 'Ver equipos', const VerEquiposScreen()),
                buildBox(context, 'Registro mantenimiento', const RegistroMantenimientoScreen()),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildBox(context, 'Eliminar', const EliminarScreen()),
                buildBox(context, 'Registro validación', const RegistroValidacionScreen()),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildBox(context, 'Notificaciones', const NotificacionesScreen()),
                buildBox(context, 'Ayuda', const AyudaScreen()),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CodeUserScreen()),
                );
              },
              child: const Text(
                '    ',//Boton invisible
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
