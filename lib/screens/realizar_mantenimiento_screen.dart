import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surmeti/screens/registro_mantenimiento_screen.dart';
import 'package:uuid/uuid.dart';
import 'ver_equipos_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RegistroMantenimientoScreen(),
    );
  }
}

class RealizarMantenimientoScreen extends StatefulWidget {
  const RealizarMantenimientoScreen({super.key});

  @override
  RealizarMantenimientoScreenState createState() =>
      RealizarMantenimientoScreenState();
}

class RealizarMantenimientoScreenState
    extends State<RealizarMantenimientoScreen> {
  final _formKey = GlobalKey<FormState>();
  String tipoEquipo = 'PC';
  String _quitarprograminicio = 'Sí';
  String _borrartemporales = 'Sí';
  String _cambiarpastermica = 'Sí';
  String _escanearantivirus = 'Sí';
  String _limpiarpc = 'Sí';
  String _limpiarram = 'Sí';
  String _limpiarranuras = 'Sí';
  String _quitarservinicio = 'Sí';
  String _vaciarpapelera = 'Sí';
  final CollectionReference _mantenimientosCollection =
      FirebaseFirestore.instance.collection('mantenimientos');
  final CollectionReference _administrativosCollection =
      FirebaseFirestore.instance.collection('administrativos');

  final TextEditingController areaControler = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController semanaController = TextEditingController();
  final TextEditingController encargadoequipoController = TextEditingController();
  final TextEditingController fechaterminoController = TextEditingController();
  final TextEditingController firmasistemasControler = TextEditingController();
  final TextEditingController observacionesController = TextEditingController();
  final TextEditingController firmaencargpclapController = TextEditingController();

  @override
  void dispose() {
    areaControler.dispose();
    fechaController.dispose();
    semanaController.dispose();
    encargadoequipoController.dispose();
    fechaterminoController.dispose();
    firmasistemasControler.dispose();
    observacionesController.dispose();
    firmaencargpclapController.dispose();
    super.dispose();
  }

  Future<bool> _verificarFirmaAU(String firma) async {
    final QuerySnapshot result = await _administrativosCollection
        .where('codigo', isEqualTo: firma)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<void> _guardarMantenimientos() async {
    final firmaAU = firmaencargpclapController.text;
    final firmaAUValida = await _verificarFirmaAU(firmaAU);

    if (!firmaAUValida) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Firma AU no válida.')),
      );
      return;
    }

    final mantenimientos = {
      'tipoEquipo': tipoEquipo,
      'fecha': fechaController.text,
      'fechatermino': fechaterminoController.text,
      'semana': semanaController.text,
      'encargadoequipo': encargadoequipoController.text,
      'area': areaControler.text,
      'borrartemporales': _borrartemporales,
      'vaciarpapelera': _vaciarpapelera,
      'quitarprograminicio': _quitarprograminicio,
      'quitarservinicio': _quitarservinicio,
      'escanearantivirus': _escanearantivirus,
      'limpiarpc': _limpiarpc,
      'cambiarpastatermica': _cambiarpastermica,
      'limpiarranuras': _limpiarranuras,
      'limpiarram': _limpiarram,
      'firmasistemas': firmasistemasControler.text,
      'firmaencargpclap': firmaencargpclapController.text,
      'observaciones':observacionesController,
    };

    try {
      await _mantenimientosCollection.add(mantenimientos);
      // Mostrar el mensaje de confirmación y redirigir a "Ver Equipos"
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Se guardó correctamente'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const RegistroMantenimientoScreen()),
                  ); // Navega a la página de Ver Equipos
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el mantenimiento: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Mantenimiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: tipoEquipo,
                decoration: const InputDecoration(labelText: 'Seleccione equipo'),
                items: ['PC', 'Laptop']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    tipoEquipo = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _borrartemporales,
                decoration: const InputDecoration(labelText: '¿Se borraron archivos temporales?'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _borrartemporales = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _vaciarpapelera,
                decoration: const InputDecoration(labelText: '¿Se vacío la papelera?'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _vaciarpapelera = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _quitarprograminicio,
                decoration: const InputDecoration(labelText: '¿Se quitaron los programas que se ejecutan al inicio?'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _quitarprograminicio = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _quitarservinicio,
                decoration: const InputDecoration(labelText: '¿Se quitaron los servicios que se ejecutan al inicio?'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _quitarservinicio = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _escanearantivirus,
                decoration: const InputDecoration(labelText: '¿Se escaneo con antivirus?'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _escanearantivirus = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _limpiarpc,
                decoration: const InputDecoration(labelText: '¿Se limpio la pc?'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _limpiarpc = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _cambiarpastermica,
                decoration: const InputDecoration(labelText: '¿Se cambio la pasta térmica?'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _cambiarpastermica = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _limpiarranuras,
                decoration: const InputDecoration(labelText: '¿Se limpiaron las ranuras?'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _limpiarranuras = value!;
                  });
                },
              ),
              DropdownButtonFormField<String>(
                value: _limpiarram,
                decoration: const InputDecoration(labelText: '¿Se realizo la memoria ram?'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _limpiarram = value!;
                  });
                },
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: fechaController,
                decoration: const InputDecoration(labelText: 'Fecha de inicio'),
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: semanaController,
                decoration: const InputDecoration(labelText: 'Semana'),
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: encargadoequipoController,
                decoration:
                    const InputDecoration(labelText: 'Encargado de PC / Laptop'),
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: areaControler,
                decoration: const InputDecoration(labelText: 'Área'),
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: observacionesController,
                decoration: const InputDecoration(labelText: 'Observaciones'),
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: firmasistemasControler,
                decoration: const InputDecoration(labelText: 'Ingrese la firma SI'),
                obscureText: true,
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: firmaencargpclapController,
                decoration: const InputDecoration(labelText: 'Ingrese la firma AU'),
                obscureText: true,
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: fechaterminoController,
                decoration: const InputDecoration(labelText: 'Fecha de termino'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarMantenimientos(); // Llamar a la función para guardar los datos
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
