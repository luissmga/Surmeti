import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:surmeti/screens/ver_equipos_screen.dart';

class AgregarAlertaScreen extends StatefulWidget {
  const AgregarAlertaScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AgregarAlertaScreenState createState() => _AgregarAlertaScreenState();
}

class _AgregarAlertaScreenState extends State<AgregarAlertaScreen> {
  final _formKey = GlobalKey<FormState>();
  final nombreController = TextEditingController();
  final areaController = TextEditingController();
  DateTime? _selectedDateTime;
  String? _tipoAlerta;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _agregarAlerta() async {
    if (_formKey.currentState!.validate() && _selectedDateTime != null && _tipoAlerta != null) {
      final alerta = {
        'nombreEquipo': nombreController.text,
        'area': areaController.text,
        'fechaHora': _selectedDateTime,
        'tipoAlerta': _tipoAlerta,
      };

      await FirebaseFirestore.instance.collection('alerta').add(alerta);

      // Schedule notifications
      _scheduleNotification(alerta);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alerta agregada exitosamente')),
      );
    }
  }

  Future<void> _scheduleNotification(Map<String, dynamic> alerta) async {
    final now = DateTime.now();
    final scheduledDate = alerta['fechaHora'] as DateTime;

    // Schedule notification one day before
    if (scheduledDate.isAfter(now.add(const Duration(days: 1)))) {
      final dayBefore = scheduledDate.subtract(const Duration(days: 1));
      await _scheduleSingleNotification(
        id: 0,
        title: 'Alerta próxima',
        body: 'La alerta de ${alerta['tipoAlerta']} está próxima',
        scheduledDate: dayBefore,
      );
    }

    // Schedule notification one hour before
    if (scheduledDate.isAfter(now.add(const Duration(hours: 1)))) {
      final hourBefore = scheduledDate.subtract(const Duration(hours: 1));
      await _scheduleSingleNotification(
        id: 1,
        title: 'Alerta próxima',
        body: 'La alerta de ${alerta['tipoAlerta']} se realizará en una hora',
        scheduledDate: hourBefore,
      );
    }
  }

  Future<void> _scheduleSingleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {


    // await flutterLocalNotificationsPlugin.schedule(
    //   id,
    //   title,
    //   body,
    //   scheduledDate,
    //   platformChannelSpecifics,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Alerta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre del equipo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre del equipo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: areaController,
                decoration: const InputDecoration(labelText: 'Área'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el área';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Fecha y hora'),
                subtitle: Text(
                  _selectedDateTime == null
                      ? 'Seleccione la fecha y hora'
                      : DateFormat.yMd().add_jm().format(_selectedDateTime!),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDateTime(context), //CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tipo de alerta'),
                value: _tipoAlerta,
                items: const [
                  DropdownMenuItem(
                    value: 'Mantenimiento',
                    child: Text('Mantenimiento'),
                  ),
                  DropdownMenuItem(
                    value: 'Validación',
                    child: Text('Validación'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipoAlerta = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione el tipo de alerta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                 onPressed: () {
                   _agregarAlerta().then((_) {
                     Navigator.push(
                     context,
                     MaterialPageRoute(
                     builder: (context) => const VerEquiposScreen(),
                    ),
                  );
                });
              },
              child: const Text('Agregar Alerta'),
            ),

            ],
          ),
        ),
      ),
    );
  }
}
