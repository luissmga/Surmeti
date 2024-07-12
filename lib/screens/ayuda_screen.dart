import 'package:flutter/material.dart';
import 'package:surmeti/theme/app_theme.dart';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda')),
      body: const Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SURMETI',
                style: AppTheme.titleTextStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Botón "Agregar":',
                style: AppTheme.subtitleTextStyle,
              ),
              SizedBox(height: 8),
              Text(
                'En esta pantalla se registrarán los nuevos equipos. Al entrar, el usuario debe seleccionar si el equipo es una PC o una Laptop. Se debe llenar el formulario indicando si el equipo tiene algún monitor extra o no. Al terminar de llenar el formulario, se debe dar clic en el botón "Guardar".',
                style: AppTheme.bodyTextStyle,
              ),
              SizedBox(height: 16),
              Text(
                'Botón "Ver equipos":',
                style: AppTheme.subtitleTextStyle,
              ),
              SizedBox(height: 8),
              Text(
                'Aquí se podrán visualizar los equipos que se han guardado (registrado). En el botón "Ver" de cada equipo se podrá visualizar toda la información del equipo. También hay tres botones adicionales:',
                style: AppTheme.bodyTextStyle,
              ),
              Text(
                '1. Agregar alerta: Permite agregar una alerta de mantenimiento o validación.',
                style: AppTheme.bodyTextStyle,
              ),
              Text(
                '2. Realizar mantenimiento: Permite llenar el formato de mantenimiento preventivo. Cuando se llegue al punto de agregar firma:\n   - FIRMA SI: Es la firma de 6 dígitos del encargado del área de sistemas.\n   - FIRMA AU: Es la firma de 6 dígitos del administrativo al que corresponde el equipo en mantenimiento. Sin la firma AU correcta no se podrá registrar el mantenimiento.',
                style: AppTheme.bodyTextStyle,
              ),
              SizedBox(height: 16),
              Text(
                'Botón "Editar":',
                style: AppTheme.subtitleTextStyle,
              ),
              SizedBox(height: 8),
              Text(
                'Esta pantalla es para editar los equipos que se han agregado. Se pueden editar todos los campos, y es utilizada cuando hay un cambio como el reemplazo de teclado, monitor o algún otro elemento.',
                style: AppTheme.bodyTextStyle,
              ),
              SizedBox(height: 16),
              Text(
                'Botón "Eliminar":',
                style: AppTheme.subtitleTextStyle,
              ),
              SizedBox(height: 8),
              Text(
                'Esta pantalla es para eliminar un equipo que dejó de funcionar o ya no se utilizará. Al dar clic en el botón "Eliminar", el equipo se eliminará por completo y NO HABRÁ FORMA DE RECUPERARLO.',
                style: AppTheme.bodyTextStyle,
              ),
              SizedBox(height: 16),
              Text(
                'Botón "Notificaciones":',
                style: AppTheme.subtitleTextStyle,
              ),
              SizedBox(height: 8),
              Text(
                'En esta pantalla se pueden observar las notificaciones programadas. Si ya se ha realizado la acción que indica la notificación, se podrá eliminar la notificación dando clic en "Eliminar".',
                style: AppTheme.bodyTextStyle,
              ),
              SizedBox(height: 16),
              Text(
                'Botón "Registro de mantenimiento":',
                style: AppTheme.subtitleTextStyle,
              ),
              SizedBox(height: 8),
              Text(
                'Aquí se podrán ver los mantenimientos que se han realizado. Al dar clic en el botón "Ver", se podrá observar la información registrada en el formulario de mantenimiento.',
                style: AppTheme.bodyTextStyle,
              ),
              SizedBox(height: 16),
              Text(
                'Botón "Registro de validación":',
                style: AppTheme.subtitleTextStyle,
              ),
              SizedBox(height: 8),
              Text(
                'Aquí se podrán ver las validaciones realizadas. Al dar clic en el botón "Ver", se podrá observar cuáles equipos pasaron la validación y cuáles no, mostrando qué elementos no se pudieron validar.',
                style: AppTheme.bodyTextStyle,
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
