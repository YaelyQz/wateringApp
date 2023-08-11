import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewPlant extends StatefulWidget {
  const ViewPlant({Key? key}) : super(key: key);

  @override
  _ViewPlantState createState() => _ViewPlantState();
}

class _ViewPlantState extends State<ViewPlant> {
  String imageUrl = 'images/image1.jpg'; // Imagen local por defecto

  void loadPlantImage() async {
    // Lógica para cargar la imagen de la planta desde el servidor
    // Realiza una solicitud HTTP para obtener la URL de la imagen desde el servidor
    final response = await http.get(Uri.parse('URL_DEL_SERVIDOR'));

    if (response.statusCode == 200) {
      setState(() {
        imageUrl = response.body; // Actualiza la URL de la imagen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.blueGrey, // Fondo oscuro
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 12),
          child: const Text(
            'Visualiza tu planta',
            style: TextStyle(
              color: Colors.white, // Texto en blanco
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            loadPlantImage(); // Cargar la imagen de la planta al tocarla
          },
          child: Image.asset(imageUrl), // Mostrar la imagen (local o del servidor)
        ),
        const SizedBox(height: 30),
        const Text(
          'Presione la imagen para ver la foto más reciente de su planta',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
      ],
    );
  }
}