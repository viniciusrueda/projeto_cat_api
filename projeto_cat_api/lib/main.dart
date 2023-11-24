import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> imageData = [];

  Future<void> fetchAndSetData() async {
    final response = await http.get(
      Uri.parse("https://api.thecatapi.com/v1/images/search?limit=5"),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // Para limitar o número de imagens, mesmo com limit na url ele sempre pega 10, então tive que usar isso
      data = data.take(5).toList();
      setState(() {
        imageData = data.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Falha ao carregar os dados da API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('App de Imagens de Gato')),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              fetchAndSetData();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: Container(
              height: 60,
              width: 300,
              padding: EdgeInsets.all(2.0),
              child: Center(
                child: Text(
                  'Clique aqui para obter 5 Imagens de gatos',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: imageData.length,
                    itemBuilder: (context, index) {
                      final imageUrl = imageData[index]['url'] as String?;
                      if (imageUrl != null) {
                        return Card(
                          child: Column(
                            children: [
                              Image.network(imageUrl),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Imagem do Gato'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Card(
                          child: Text('Dados de imagem inválidos'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}