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
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Programa el riego de tus plantas",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Seleccione las opciones para adaptar el riego a las necesidades de su planta"),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
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
                  border: Border.all(color: Colors.blueGrey),
                ),
                child: Text(
                  selectedDate != null
                      ? 'Fecha seleccionada: ${selectedDate!.toLocal()}'
                      : 'Seleccionar fecha de inicio',
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Botón
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Espaciado interno
              ),
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
      El riego se realizará cada $selectedInterval hrs durante $selectedDuration minutos a partir del día ${selectedDate?.toLocal() ?? 'Fecha no seleccionada'}
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
