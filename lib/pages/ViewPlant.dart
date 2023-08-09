import 'package:flutter/material.dart';

class ViewPlant extends StatelessWidget {
  const ViewPlant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('images/image1.jpg'),
        const SizedBox(height: 30), // Espacio entre la imagen y el texto
        const Text(
          'Presione el recuadro para visualizar la imagen más reciente de su planta',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
