import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WebScraping extends StatefulWidget {
  @override
  _WebScrapingState createState() => _WebScrapingState();
}

class _WebScrapingState extends State<WebScraping> {
  final TextEditingController _searchController = TextEditingController();
  late List<String> _plantSuggestions = []; // Suggestions for autocompletion
  late String _selectedPlant = ''; // Currently selected plant
  late List<dynamic> _plantData = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //_searchController.addListener(_onSearchChanged);
    _searchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Información sobre plantas'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _plantSuggestions
                      .where((suggestion) =>
                      suggestion.toLowerCase().contains(textEditingValue.text.toLowerCase()))
                      .toList();
                },
                onSelected: (String selected) {
                  _searchController.text = selected;
                  _selectedPlant = selected;
                  _searchPlant(selected);
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      hintText: 'Ingrese el nombre de la planta',
                    ),
                  );
                },
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_plantData.isNotEmpty)
                Expanded(
                  child: ListView(
                    children: _plantData.map((plant){
                      return  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (plant!['latin'] != null)
                            Text(
                              'Nombre en latín: ${plant!['latin']}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          if (plant!['climate'] != null)
                            Text(
                              'Características: ${plant!['climate']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          if (plant!['ideallight'] != null)
                            Text(
                              'Cuidados: ${plant!['ideallight']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          if (plant!['watering'] != null)
                            Text(
                              'Recomendaciones de riego: ${plant!['watering']}',
                              style: const TextStyle(fontSize: 16),
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

  void _onSearchChanged() async {
    final url = 'https://house-plants.p.rapidapi.com/common/suggestions'; // API URL for getting plant suggestions
    final response = await http.get(Uri.parse(url),
        headers: {'X-RapidAPI-Key': '82c2f4b390msh89af739208246d0p1afc01jsnf8c36d846c52'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _plantSuggestions = List<String>.from(data['suggestions']);
      });
    }
  }
  void _searchAll() async {
    final url = 'https://house-plants.p.rapidapi.com/all'; // API URL for getting plant suggestions
    final response = await http.get(Uri.parse(url),
        headers: {'X-RapidAPI-Key': '82c2f4b390msh89af739208246d0p1afc01jsnf8c36d846c52'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      var names = data.map((item) => item['common'].length > 0  ? item['common'][0] as String: item['latin'] as String)?.toList();
      setState(() {
        _plantSuggestions = List<String>.from(names);
      });
    }
  }

  void _searchPlant(String plantName) async {
    setState(() {
      _isLoading = true;
      _plantData = [];
    });

    final url = 'https://house-plants.p.rapidapi.com/common'; // API URL for web scraping plants
    final response = await http.get(
        Uri.parse('$url/$_selectedPlant'),
        headers: {
          'X-RapidAPI-Key': '82c2f4b390msh89af739208246d0p1afc01jsnf8c36d846c52'
        });

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: WebScraping(),
  ));
}