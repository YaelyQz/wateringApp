import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            color: Colors.blueGrey, // Fondo oscuro
            padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 12),
            child: const Text(
              'Información del sistema',
              style: TextStyle(
                color: Colors.white, // Texto en blanco
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            //child: const Text('Información del sistema'),
          )
        ],
      ),
    );
  }
}