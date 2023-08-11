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
        padding: const EdgeInsets.all(10),
        children: [
          const SizedBox(height: 24),
          RiegoButton(),
          const SizedBox(height: 30), // Espaciado entre el título y el mensaje de humedad
          Container(
            color: Colors.blueGrey, // Fondo oscuro
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Text(
              'Detección de humedad',
              style: TextStyle(
                color: Colors.white, // Texto en blanco
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const HumedadIndicator(),
          const SizedBox(height: 10),
          Container(
            color: Colors.blueGrey, // Fondo oscuro
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Text(
              'Historial de Riego',
              style: TextStyle(
                color: Colors.white, // Texto en blanco
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 10), // Espaciado entre el título y el calendario
          const HistorialCalendario(),
        ],
      ),
    );
  }
}

class RiegoButton extends StatefulWidget {
  @override
  _RiegoButtonState createState() => _RiegoButtonState();
}

class _RiegoButtonState extends State<RiegoButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Lógica del botón de riego
          // loading 5 segundos mínimo y deshabilitar el botón
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Botón
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Espaciado interno
        ),
        child: const Text(
          'Activar Riego',
          style: TextStyle(fontSize: 18), // Tamaño del texto
        ),
      ),
    );
  }
}

class HumedadIndicator extends StatefulWidget {
  const HumedadIndicator({super.key});

  @override
  _HumedadIndicatorState createState() => _HumedadIndicatorState();
}

class _HumedadIndicatorState extends State<HumedadIndicator> {
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
          child: Column(
            children: [
              Icon(
                humedadPresente ? Icons.water_drop_rounded : Icons.cloud_off,
                size: 60,
                color: humedadPresente ? Colors.blue : Colors.blueGrey,
              ),
              const SizedBox(height: 10), // Espaciado entre el ícono y el texto
              Text(
                humedadPresente
                    ? 'Humedad detectada en la tierra'
                    : 'No se detecta humedad en la tierra',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistorialCalendario extends StatefulWidget {
  const HistorialCalendario({super.key});

  @override
  _HistorialCalendarioState createState() => _HistorialCalendarioState();
}

class _HistorialCalendarioState extends State<HistorialCalendario> {
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
      padding: const EdgeInsets.all(12.0),
      child: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: const MonthViewSettings(
          showAgenda: true,
          navigationDirection: MonthNavigationDirection.horizontal,
        ),
        dataSource: _RiegoDataSource(fechasDeRiego),
        appointmentBuilder: _appointmentBuilder,
        monthCellBuilder: (BuildContext context, MonthCellDetails cellDetails) {
          // Personaliza el estilo de las celdas del mes aquí
          return Center(
            child: Text(
              '${cellDetails.date.day}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _appointmentBuilder(BuildContext context, CalendarAppointmentDetails details) {
    if (fechasDeRiego.contains(details.date)) {
      return Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: const Center(
          child: Icon(
            Icons.water_drop,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
    }
    return Container();
  }
}

class _RiegoDataSource extends CalendarDataSource {
  _RiegoDataSource(List<DateTime> source) {
    appointments = source.map((date) {
      return Appointment(
        startTime: date,
        endTime: date.add(const Duration(minutes: 30)),
      );
    }).toList();
  }
}


