import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      // title: 'Flutter Firebase Demo',
      home: AgregarScreen(),
    );
  }
}

class AgregarScreen extends StatefulWidget {
  const AgregarScreen({super.key});

  @override
  _AgregarScreenState createState() => _AgregarScreenState();
}

class _AgregarScreenState extends State<AgregarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid(); // Instancia para generar UUID
  String _tipoEquipo = 'PC';
  String _monitorExtra = 'No';
  String _idAutomatico = '';
  final CollectionReference _equiposCollection = FirebaseFirestore.instance.collection('equipos');

  // Controladores para los campos del formulario
  final TextEditingController areaController = TextEditingController();
  final TextEditingController responsableController = TextEditingController();
  final TextEditingController nombreEquipoController = TextEditingController();
  final TextEditingController memoriaSSDController = TextEditingController();
  final TextEditingController memoriaHDDController = TextEditingController();
  final TextEditingController ramController = TextEditingController();
  final TextEditingController marcaMonitorController = TextEditingController();
  final TextEditingController marcaGabineteController = TextEditingController();
  final TextEditingController marcaTecladoController = TextEditingController();
  final TextEditingController marcaMouseController = TextEditingController();
  final TextEditingController marcaMonitorExtraController = TextEditingController();
  final TextEditingController tipoConexionController = TextEditingController();
  final TextEditingController impresoraPredeterminadaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _idAutomatico = _uuid.v4(); // Generar ID automático al iniciar la página
  }

  @override
  void dispose() {
    // Liberar controladores cuando no se necesiten
    areaController.dispose();
    responsableController.dispose();
    nombreEquipoController.dispose();
    memoriaSSDController.dispose();
    memoriaHDDController.dispose();
    ramController.dispose();
    marcaMonitorController.dispose();
    marcaGabineteController.dispose();
    marcaTecladoController.dispose();
    marcaMouseController.dispose();
    marcaMonitorExtraController.dispose();
    tipoConexionController.dispose();
    impresoraPredeterminadaController.dispose();
    super.dispose();
  }

  Future<void> _guardarEquipo() async {
    // Crear un mapa con los datos del formulario
    final equipoData = {
      'tipoEquipo': _tipoEquipo,
      'area': areaController.text,
      'responsable': responsableController.text,
      'nombreEquipo': nombreEquipoController.text,
      'memoriaSSD': memoriaSSDController.text,
      'memoriaHDD': memoriaHDDController.text,
      'ram': ramController.text,
      'marcaTeclado': marcaTecladoController.text,
      'marcaMouse': marcaMouseController.text,
      'monitorExtra': _monitorExtra,
      'tipoConexion': tipoConexionController.text,
      'impresoraPredeterminada': impresoraPredeterminadaController.text,
      'idAutomatico': _idAutomatico,
    };

    if (_tipoEquipo == 'PC') {
      equipoData['marcaMonitor'] = marcaMonitorController.text;
      equipoData['marcaGabinete'] = marcaGabineteController.text;
    }

    if (_monitorExtra == 'Sí') {
      equipoData['marcaMonitorExtra'] = marcaMonitorExtraController.text;
    }

    // Guardar los datos en Firebase Firestore
    try {
      await _equiposCollection.add(equipoData);
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
                    MaterialPageRoute(builder: (context) => const VerEquiposScreen()),
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
        SnackBar(content: Text('Error al guardar el equipo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Equipo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _tipoEquipo,
                decoration: const InputDecoration(labelText: 'Seleccione equipo'),
                items: ['PC', 'Laptop']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoEquipo = value!;
                  });
                },
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: areaController,
                decoration: const InputDecoration(labelText: 'area'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: responsableController,
                decoration: const InputDecoration(labelText: 'Responsable del equipo'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: nombreEquipoController,
                decoration: const InputDecoration(labelText: 'Nombre del equipo'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: memoriaSSDController,
                decoration: const InputDecoration(labelText: 'Memoria SSD'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: memoriaHDDController,
                decoration: const InputDecoration(labelText: 'Memoria HDD'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: ramController,
                decoration: const InputDecoration(labelText: 'RAM'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              if (_tipoEquipo == 'PC') ...[
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: marcaMonitorController,
                  decoration: const InputDecoration(labelText: 'Marca del monitor'),
                ),
                const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: marcaGabineteController,
                  decoration: const InputDecoration(labelText: 'Marca del gabinete'),
                ),
              ],
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: marcaTecladoController,
                decoration: const InputDecoration(labelText: 'Marca del teclado'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: marcaMouseController,
                decoration: const InputDecoration(labelText: 'Marca del mouse'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _monitorExtra,
                decoration: const InputDecoration(labelText: 'Monitor extra'),
                items: ['Sí', 'No']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _monitorExtra = value!;
                  });
                },
              ),
              if (_monitorExtra == 'Sí') ...[
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: marcaMonitorExtraController,
                  decoration: const InputDecoration(labelText: 'Marca del monitor extra'),
                ),
              ],
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: tipoConexionController,
                decoration: const InputDecoration(labelText: 'Tipo de conexión'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: impresoraPredeterminadaController,
                decoration: const InputDecoration(labelText: 'Impresora Predeterminada'),
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ID Automático'),
                initialValue: _idAutomatico,
                readOnly: true,
              ),
              const Divider(
                    color: Color.fromARGB(255, 75, 21, 85),
                    thickness: 2,
                  ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _guardarEquipo(); // Llamar a la función para guardar los datos
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
