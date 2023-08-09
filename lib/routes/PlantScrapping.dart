import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:cached_network_image/cached_network_image.dart';

class WebScraping extends StatefulWidget {
  @override
  _WebScrapingState createState() => _WebScrapingState();
}

class _WebScrapingState extends State<WebScraping> {
  final TextEditingController _searchController = TextEditingController();
  late List<dynamic> _plantData = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información sobre plantas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ingrese el nombre de la planta',
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchPlant(_searchController.text);
                  },
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            if (_isLoading)
              CircularProgressIndicator()
            else if (_plantData.isNotEmpty)
              Expanded(
                child: ListView(
                  children: _plantData.map((plant){
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (plant!['latin'] != null)
                          Text(
                            'Nombre: ${plant!['latin']}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        if (plant!['climate'] != null)
                          Text(
                            'Características: ${plant!['climate']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        if (plant!['ideallight'] != null)
                          Text(
                            'Cuidados: ${plant!['ideallight']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        if (plant!['watering'] != null)
                          Text(
                            'Recomendaciones de riego: ${plant!['watering']}',
                            style: TextStyle(fontSize: 16),
                          ),
                      ],
                    );
                  }).toList(),
                ) ,
              )

    ],
        ),
      )
    );
  }

  void _searchPlant(String plantName) async {
    setState(() {
      _isLoading = true;
      _plantData  = [];
    });

    final url =
        'https://house-plants.p.rapidapi.com/common'; // Replace with the API URL for web scraping plants
    final response = await http.get(Uri.parse('$url/$plantName'),headers: {'X-RapidAPI-Key': '82c2f4b390msh89af739208246d0p1afc01jsnf8c36d846c52'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _plantData = data;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // Handle error when the plant data couldn't be fetched.
      // You can show an error message to the user here.
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: WebScraping(),
  ));
}
