import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';
import 'ver_equipos_screen.dart';

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
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref().child('equipos');

  // Controladores para los campos del formulario
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _nombreEquipoController = TextEditingController();
  final TextEditingController _memoriaSSDController = TextEditingController();
  final TextEditingController _memoriaHDDController = TextEditingController();
  final TextEditingController _ramController = TextEditingController();
  final TextEditingController _marcaMonitorController = TextEditingController();
  final TextEditingController _marcaGabineteController = TextEditingController();
  final TextEditingController _marcaTecladoController = TextEditingController();
  final TextEditingController _marcaMouseController = TextEditingController();
  final TextEditingController _marcaMonitorExtraController = TextEditingController();
  final TextEditingController _tipoConexionController = TextEditingController();
  final TextEditingController _impresoraPredeterminadaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _idAutomatico = _uuid.v4(); // Generar ID automático al iniciar la página
  }

  @override
  void dispose() {
    // Liberar controladores cuando no se necesiten
    _areaController.dispose();
    _responsableController.dispose();
    _nombreEquipoController.dispose();
    _memoriaSSDController.dispose();
    _memoriaHDDController.dispose();
    _ramController.dispose();
    _marcaMonitorController.dispose();
    _marcaGabineteController.dispose();
    _marcaTecladoController.dispose();
    _marcaMouseController.dispose();
    _marcaMonitorExtraController.dispose();
    _tipoConexionController.dispose();
    _impresoraPredeterminadaController.dispose();
    super.dispose();
  }

  Future<void> _guardarEquipo() async {
    // Crear un mapa con los datos del formulario
    final equipoData = {
      'tipoEquipo': _tipoEquipo,
      'area': _areaController.text,
      'responsable': _responsableController.text,
      'nombreEquipo': _nombreEquipoController.text,
      'memoriaSSD': _memoriaSSDController.text,
      'memoriaHDD': _memoriaHDDController.text,
      'ram': _ramController.text,
      'marcaTeclado': _marcaTecladoController.text,
      'marcaMouse': _marcaMouseController.text,
      'monitorExtra': _monitorExtra,
      'tipoConexion': _tipoConexionController.text,
      'impresoraPredeterminada': _impresoraPredeterminadaController.text,
      'idAutomatico': _idAutomatico,
    };

    if (_tipoEquipo == 'PC') {
      equipoData['marcaMonitor'] = _marcaMonitorController.text;
      equipoData['marcaGabinete'] = _marcaGabineteController.text;
    }

    if (_monitorExtra == 'Sí') {
      equipoData['marcaMonitorExtra'] = _marcaMonitorExtraController.text;
    }

    // Guardar los datos en Firebase Realtime Database
    await _databaseReference.push().set(equipoData);

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
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(labelText: 'Área'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _responsableController,
                decoration: const InputDecoration(labelText: 'Responsable del equipo'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nombreEquipoController,
                decoration: const InputDecoration(labelText: 'Nombre del equipo'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _memoriaSSDController,
                decoration: const InputDecoration(labelText: 'Memoria SSD'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _memoriaHDDController,
                decoration: const InputDecoration(labelText: 'Memoria HDD'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ramController,
                decoration: const InputDecoration(labelText: 'RAM'),
              ),
              if (_tipoEquipo == 'PC') ...[
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _marcaMonitorController,
                  decoration: const InputDecoration(labelText: 'Marca del monitor'),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _marcaGabineteController,
                  decoration: const InputDecoration(labelText: 'Marca del gabinete'),
                ),
              ],
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _marcaTecladoController,
                decoration: const InputDecoration(labelText: 'Marca del teclado'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _marcaMouseController,
                decoration: const InputDecoration(labelText: 'Marca del mouse'),
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
                  controller: _marcaMonitorExtraController,
                  decoration: const InputDecoration(labelText: 'Marca del monitor extra'),
                ),
              ],
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _tipoConexionController,
                decoration: const InputDecoration(labelText: 'Tipo de conexión'),
              ),
              const SizedBox(height: 16.0),
                               TextFormField(
                   controller: _impresoraPredeterminadaController,
                   decoration: const InputDecoration(labelText: 'Impresora Predeterminada'),
                 ),
                 const SizedBox(height: 16.0),
                 TextFormField(
                   decoration: const InputDecoration(labelText: 'ID Automático'),
                   initialValue: _idAutomatico,
                   readOnly: true,
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
