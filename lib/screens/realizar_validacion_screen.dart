import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:surmeti/theme/app_theme.dart';
import 'package:surmeti/screens/agregar_alerta_screen.dart';
import 'package:surmeti/screens/realizar_mantenimiento_screen.dart';

class RealizarValidacionScreen extends StatefulWidget {
  final DocumentSnapshot doc;

  const RealizarValidacionScreen({super.key, required this.doc});

  @override
  _RealizarValidacionScreenState createState() => _RealizarValidacionScreenState();
}
//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
class _RealizarValidacionScreenState extends State<RealizarValidacionScreen> {
  String? aprobado;
  String? elementosNoValidos;
  DateTime? fechaValidacion;
  final TextEditingController _elementosNoValidadosController = TextEditingController();
  final TextEditingController _fechaValidacionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = widget.doc.data() as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('Realizar Validación')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('ID: ${widget.doc.id}', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text('Área: ${data['area']}', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              ...data.entries.map((entry) {
                return Text('${entry.key}: ${entry.value}', style: AppTheme.bodyTextStyle);
              }).toList(),
              const Divider(thickness: 2, height: 40, color: AppTheme.dividerColor),
              const Text('Aprobado:', style: AppTheme.labelTextStyle),
              DropdownButton<String>(
                value: aprobado,
                items: <String>['Sí', 'No'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: AppTheme.dropdownTextStyle),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    aprobado = newValue;
                    if (aprobado == 'Sí') {
                      elementosNoValidos = null;
                      _elementosNoValidadosController.clear();
                    }
                  });
                },
              ),
              if (aprobado == 'No') ...[
                const Text('¿Qué elemento o elementos no pasaron la validación?', style: AppTheme.labelTextStyle),
                TextField(
                  controller: _elementosNoValidadosController,
                  onChanged: (value) {
                    elementosNoValidos = value;
                  },//CODIGO POR LUIS RODOLFO SANCHEZ MUNGUÍA (LM)
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Ingrese los elementos',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              const Text('Fecha de validación:', style: AppTheme.labelTextStyle),
              TextField(
                controller: _fechaValidacionController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Seleccione la fecha',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      fechaValidacion = pickedDate;
                      _fechaValidacionController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (fechaValidacion == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, seleccione una fecha de validación')),
                    );
                    return;
                  }
                  await FirebaseFirestore.instance.collection('validaciones').add({
                    'ID': widget.doc.id,
                    'Área': data['area'],
                    ...data,
                    'Aprobado': aprobado,
                    'FechaValidacion': fechaValidacion?.toIso8601String().split('T')[0], // Solo la fecha
                    if (aprobado == 'No') 'ElementosNoValidados': elementosNoValidos,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Validación guardada')),
                  );
                },
                child: const Text('Guardar Validación'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildBox(BuildContext context, String title, Widget screen) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
    ),
  );
}
