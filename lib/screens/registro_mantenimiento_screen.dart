import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroMantenimientoScreen extends StatefulWidget {
  const RegistroMantenimientoScreen({super.key});

  @override
  _RegistroMantenimientoScreenState createState() =>
      _RegistroMantenimientoScreenState();
}

class _RegistroMantenimientoScreenState
    extends State<RegistroMantenimientoScreen> {
  final CollectionReference _mantenimientosCollection =
      FirebaseFirestore.instance.collection('mantenimientos');
  final CollectionReference _administrativosCollection =
      FirebaseFirestore.instance.collection('administrativos');

  Future<String> _getIDFromFirmaAU(String firmaAU) async {
    final QuerySnapshot result = await _administrativosCollection
        .where('codigo', isEqualTo: firmaAU)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      return result.docs.first.id;
    } else {
      return 'ID no encontrado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Mantenimientos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _mantenimientosCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<DocumentSnapshot> docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> data =
                  docs[index].data() as Map<String, dynamic>;
              final String fecha = data['fecha'];
              final String firmaAU = data['firmaencargpclap'];
              return FutureBuilder<String>(
                future: _getIDFromFirmaAU(firmaAU),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Cargando ID...'),
                      subtitle: Text('Fecha de mantenimiento: Cargando...'),
                    );
                  } else if (snapshot.hasError) {
                    return ListTile(
                      title: const Text('Error al obtener ID'),
                      subtitle: Text('Fecha de mantenimiento: $fecha'),
                    );
                  } else {
                    final String idAU = snapshot.data!;//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
                    return ListTile(
                      title: Text('$idAU'),
                      subtitle: Text('Fecha de mantenimiento: $fecha'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleMantenimientoScreen(
                                mantenimiento: data,
                                firmaSI: data['firmasistemas'],
                                firmaAU: firmaAU,
                              ),
                            ),
                          );
                        },
                        child: const Text('Ver'),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class DetalleMantenimientoScreen extends StatelessWidget {
  final Map<String, dynamic> mantenimiento;
  final String firmaSI;
  final String firmaAU;

  const DetalleMantenimientoScreen({
    super.key,
    required this.mantenimiento,
    required this.firmaSI,
    required this.firmaAU,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Mantenimiento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
                'Tipo de equipo:                               ${mantenimiento['tipoEquipo']}'),
            Text(
                'Fecha de inicio:                              ${mantenimiento['fecha']}'),
            Text(
                'Semana:                                          ${mantenimiento['semana']}'),
            Text(
                'Encargado de PC / Laptop:           ${mantenimiento['encargadoequipo']}'),
            Text(
                'Área:                                                ${mantenimiento['area']}'),
            const Divider(
              color: Color.fromARGB(255, 139, 0, 174),
              thickness: 2,
            ),
            Text(
                'Borrar archivos temporales:                                  ${mantenimiento['borrartemporales']}'),
            Text(
                'Vaciar papelera de reciclaje:                                 ${mantenimiento['vaciarpapelera']}'),
            Text(
                'Quitar programas que se ejecutan al inicio:        ${mantenimiento['quitarprograminicio']}'),
            Text(
                'Quitar los servicios que se ejecutan al inicio:     ${mantenimiento['quitarservinicio']}'),
            Text(
                'Escanear pc con antivirus:                                    ${mantenimiento['escanearantivirus']}'),
            Text(
                'Limpiar pc:                                                              ${mantenimiento['limpiarpc']}'),
            Text(
                'Cambiar pasta térmica:                                         ${mantenimiento['cambiarpastatermica']}'),
            Text(
                'Limpiar ranuras:                                                     ${mantenimiento['limpiarranuras']}'),
            Text(
                'Limpiar memoria ram:                                           ${mantenimiento['limpiarram']}'),
            const Divider(
              color: Color.fromARGB(255, 139, 0, 174),
              thickness: 2,
            ),
            Text(
                'Observaciones:            ${mantenimiento['observaciones']}'),
            const Divider(
              color: Color.fromARGB(255, 139, 0, 174),
              thickness: 2,
            ),
            Text(
                'Firma SI:                       ${firmaSI.substring(firmaSI.length - 2)}'),
            Text(
                'Firma AU:                     ${firmaAU.substring(firmaAU.length - 2)}'),
            const Divider(
              color: Color.fromARGB(255, 139, 0, 174),
              thickness: 2,
            ),
            Text('Fecha de termino:       ${mantenimiento['fechatermino']}'),
          ],
        ),
      ),
    );
  }
}
