import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarEquipoScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditarEquipoScreen(
      {super.key, required this.docId, required this.data});

  @override
  _EditarEquipoScreenState createState() => _EditarEquipoScreenState();
}

class _EditarEquipoScreenState extends State<EditarEquipoScreen> {
  late TextEditingController areaController;
  late TextEditingController responsableController;
  late TextEditingController nombreEquipoController;
  late TextEditingController memoriaSSDController;
  late TextEditingController memoriaHDDController;
  late TextEditingController ramController;
  late TextEditingController marcaMonitorController;
  late TextEditingController marcaGabineteController;
  late TextEditingController marcaTecladoController;
  late TextEditingController marcaMouseController;
  late TextEditingController marcaMonitorExtraController;
  late TextEditingController tipoConexionController;
  late TextEditingController impresoraPredeterminadaController;

  String _tipoEquipo = 'PC';
  String _monitorExtra = 'No';

  @override
  void initState() {
    super.initState();

    areaController = TextEditingController(text: widget.data['area']);
    responsableController =
        TextEditingController(text: widget.data['responsable']);
    nombreEquipoController =
        TextEditingController(text: widget.data['nombreEquipo']);
    memoriaSSDController =
        TextEditingController(text: widget.data['memoriaSSD']);
    memoriaHDDController =
        TextEditingController(text: widget.data['memoriaHDD']);
    ramController = TextEditingController(text: widget.data['ram']);
    marcaMonitorController =
        TextEditingController(text: widget.data['marcaMonitor']);
    marcaGabineteController =
        TextEditingController(text: widget.data['marcaGabinete']);
    marcaTecladoController =
        TextEditingController(text: widget.data['marcaTeclado']);
    marcaMouseController =
        TextEditingController(text: widget.data['marcaMouse']);
    marcaMonitorExtraController =
        TextEditingController(text: widget.data['marcaMonitorExtra']);
    tipoConexionController =
        TextEditingController(text: widget.data['tipoConexion']);
    impresoraPredeterminadaController =
        TextEditingController(text: widget.data['impresoraPredeterminada']);

    _tipoEquipo = widget.data['tipoEquipo'] ?? 'PC';
    _monitorExtra = widget.data['monitorExtra'] ?? 'No';
  }
//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
  Future<void> _updateEquipo() async {
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
    };

    if (_tipoEquipo == 'PC') {
      equipoData['marcaMonitor'] = marcaMonitorController.text;
      equipoData['marcaGabinete'] = marcaGabineteController.text;
    }

    if (_monitorExtra == 'Sí') {
      equipoData['marcaMonitorExtra'] = marcaMonitorExtraController.text;
    }

    await FirebaseFirestore.instance
        .collection('equipos')
        .doc(widget.docId)
        .update(equipoData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Equipo actualizado exitosamente')),
    );

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Equipo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: <Widget>[
              DropdownButtonFormField<String>(
                value: _tipoEquipo,
                decoration:
                    const InputDecoration(labelText: 'Seleccione equipo'),
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
                decoration: const InputDecoration(labelText: 'Área'),
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: responsableController,
                decoration:
                    const InputDecoration(labelText: 'Responsable del equipo'),
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: nombreEquipoController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del equipo'),
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
              ),//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
              const SizedBox(height: 16.0),//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
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
                  decoration:
                      const InputDecoration(labelText: 'Marca del monitor'),
                ),
                const Divider(
                  color: Color.fromARGB(255, 75, 21, 85),
                  thickness: 2,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: marcaGabineteController,
                  decoration:
                      const InputDecoration(labelText: 'Marca del gabinete'),
                ),
              ],
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: marcaTecladoController,
                decoration:
                    const InputDecoration(labelText: 'Marca del teclado'),
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
                  decoration: const InputDecoration(
                      labelText: 'Marca del monitor extra'),
                ),
              ],
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: tipoConexionController,
                decoration:
                    const InputDecoration(labelText: 'Tipo de conexión'),
              ),
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: impresoraPredeterminadaController,
                decoration: const InputDecoration(
                    labelText: 'Impresora Predeterminada'),
              ),//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
              const Divider(
                color: Color.fromARGB(255, 75, 21, 85),
                thickness: 2,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  _updateEquipo();
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
