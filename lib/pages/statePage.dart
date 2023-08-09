import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  runApp(const MaterialApp(
    home: StatePage(),
  ));
}

class StatePage extends StatelessWidget {
  const StatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 24),
          Riego(),
          const SizedBox(height: 24),
          Humedad(),
          const SizedBox(height: 24),
          const Text(
            'Historial de Riego',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Historial(),
        ],
      ),
    );
  }
}

class Riego extends StatefulWidget {
  @override
  _RiegoState createState() => _RiegoState();
}

class _RiegoState extends State<Riego> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Lógica del botón de riego
        },
        child: const Text('Botón de riego'),
      ),
    );
  }
}

class Humedad extends StatefulWidget {
  const Humedad({super.key});

  @override
  _HumedadState createState() => _HumedadState();
}

class _HumedadState extends State<Humedad> {
  bool humedadPresente = false; // Cambia según la detección de humedad

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              humedadPresente
                  ? 'Humedad detectada en la tierra'
                  : 'No se detecta humedad en la tierra',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class Historial extends StatefulWidget {
  const Historial({super.key});

  @override
  _HistorialState createState() => _HistorialState();
}

class _HistorialState extends State<Historial> {
  // Simulación de fechas de riego para el calendario
  final List<DateTime> fechasDeRiego = [
    DateTime(2023, 8, 1),
    DateTime(2023, 8, 6),
    DateTime(2023, 8, 18),
    DateTime(2023, 8, 23),
    // Agregar más fechas aquí
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          navigationDirection: MonthNavigationDirection.horizontal,
        ),
        dataSource: _RiegoDataSource(fechasDeRiego),
        appointmentBuilder: _appointmentBuilder,
      ),
    );
  }

  Widget _appointmentBuilder(BuildContext context, CalendarAppointmentDetails details) {
    if (fechasDeRiego.contains(details.date)) {
      return const Icon(Icons.water_drop, color: Colors.blue);
    }
    return Container();
  }
}

class _RiegoDataSource extends CalendarDataSource {
  _RiegoDataSource(List<DateTime> source) {
    appointments = source.map((date) {
      return Appointment(
        startTime: date,
        endTime: date.add(Duration(minutes: 30)),
      );
    }).toList();
  }
}