import 'dart:convert';

import 'package:biblioteca_flutter/entities/investimento.dart';
import 'package:biblioteca_flutter/entities/objetivo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/api.dart';

bool criarCard = false;
bool isVisible2 = true;
String? myData;

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabHome();
}

class _TabHome extends State<TabHome> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Objetivo>> futureObjetivos;



  Future<List<Objetivo>> _fetchObjetivos() async {
    const url = '$baseURL/objetivos';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse.map((livro) => Objetivo.fromJson(livro)).toList();
    } else {
      Fluttertoast.showToast(
          msg: 'Erro ao listar os livros!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          fontSize: 20.0);
      throw ('Sem livros');
    }
  }



  @override
  void initState() {
    super.initState();
    futureObjetivos = _fetchObjetivos();
  }






  Widget buildThis() {
    return FutureBuilder<List<Objetivo>>(
      future: futureObjetivos,
      builder: (context, snapshot) {
        if (myData == 'a') {
          List<Objetivo> _investimento = snapshot.data!;
          return ListView.builder(
              itemCount: _investimento.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: const Color.fromRGBO(51, 51, 51, 1.0),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'nome: ${_investimento[index].nome}',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              });
        } else if (myData == "error") {
          return const Text("Sem investimentos");
        }
        // By default show a loading spinner.
        return const Text("Sem investimentos");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
      body: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[

                Container(
                  height: 500,
                  child:  buildThis(),

                ),
              ],
            ),
          )),
    );
  }
}
