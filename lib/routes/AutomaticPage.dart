import 'package:flutter/material.dart';

class AutomaticPage extends StatefulWidget {
  @override
  _AutomaticPageState createState() => _AutomaticPageState();
}

class _AutomaticPageState extends State<AutomaticPage> {
  String selectedInterval = '1'; // Valor inicial para el drop-down "programar cada"
  String selectedDuration = '1'; // Valor inicial para el drop-down "duración"
  DateTime? selectedDate; // Variable para almacenar la fecha seleccionada

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riego automático'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("Seleccione las opciones para programar el riego de las plantas"),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Regar cada'),
              value: selectedInterval,
              items: List.generate(24, (index) {
                return DropdownMenuItem<String>(
                  value: (index + 1).toString(),
                  child: Text('${index + 1} hrs'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  selectedInterval = value!;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Seleccione una opción';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Duración'),
              value: selectedDuration,
              items: ['1', '2', '3'].map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text('$value min'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDuration = value!;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Seleccione una opción';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  selectedDate != null
                      ? 'Fecha seleccionada: ${selectedDate!.toLocal()}'
                      : 'Seleccionar fecha de inicio',
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _showResults();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showResults() {
    String message = '''
      El riego se realizará cada $selectedInterval hrs durante $selectedDuration minutos a partir del día ${selectedDate?.toLocal() ?? 'No seleccionada'}
    ''';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Opciones seleccionadas'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AutomaticPage(),
  ));
}
