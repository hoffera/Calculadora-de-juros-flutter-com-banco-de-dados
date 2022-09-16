import 'dart:convert';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:biblioteca_flutter/entities/objetivo.dart';
import 'package:biblioteca_flutter/entities/usuario.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/api.dart';

bool criarCard = false;
bool isVisible2 = false;
String? myData;
Usuario? usuario2;

class TabHome extends StatefulWidget {
  const TabHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabHome();
}

class _TabHome extends State<TabHome> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Objetivo>> futureObjetiv;
  late Future<Usuario> futureUsuario;

  late Objetivo objetivo = Objetivo(
      id: 0, nome: "", valorEntrada: 0, valorEstimado: 0, valorMensal: "0");

  @override
  void initState() {
    super.initState();
    futureObjetiv = _fetchObjetivos();
    futureUsuario = _fetchUsuario();
  }

  Future<Usuario> _fetchUsuario() async {
    const url = '$baseURL/usuarios/getUsuario';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse =
          json.decode(utf8.decode(response.bodyBytes));
      usuario2 = Usuario.fromJson(jsonResponse);

      Usuario usuario = Usuario.fromJson(jsonResponse);
      return usuario;
    } else {
      Fluttertoast.showToast(
          msg: 'Erro ao listar os usuario',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          fontSize: 20.0);
      throw ('Sem Usuário');
    }
  }

  Future<List<Objetivo>> _fetchObjetivos() async {
    var url = '$baseURL/objetivos';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      print(response.body);

      try {
        var aux = jsonResponse.map((obj) => Objetivo.fromJson(obj)).toList();
        return aux;
      } catch (err, stack) {
        return [];
      }
    } else {
      throw ('Sem ');
    }
  }

  Widget buildThis() {
    return FutureBuilder<List<Objetivo>>(
      future: futureObjetiv,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Objetivo> _objetivo = snapshot.data!;
          return ListView.builder(

              itemCount: _objetivo.length,
              itemBuilder: (BuildContext context, int index) {
                if (usuario2?.id == _objetivo[index].usuario?.id) {
                  return Container(
                    padding: EdgeInsets.only(top: 10),
                    child: ExpansionTileCard(
                    baseColor: Colors.white,
                    expandedColor: Colors.blue[50],

                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [


                        Text('${_objetivo[index].nome}', style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 25,

                            color: Colors.black),),
                        Icon(Icons.show_chart_rounded, size: 30),
                      ],
                    ),
                    subtitle: Text('Valor mensal : ${_objetivo[index].valorMensal}', style: const TextStyle(
                        fontFamily: 'BebasNeue',
                        fontSize: 20,

                        color: Colors.grey),),
                    children: <Widget>[
                      Divider(
                        thickness: 1.0,
                        height: 1.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'Investimento : ${_objetivo[index].investimento?.investimento}\nRisco : ${_objetivo[index].investimento?.risco?.nome}\nValor entrada : ${_objetivo[index].valorEntrada}\nValor estimado : ${_objetivo[index].valorEstimado}\nTempo : ${_objetivo[index].tempoConclusao} Meses',
                            style: const TextStyle(
                                fontFamily: 'BebasNeue',
                                fontSize: 20,
                                color: Colors.grey),

                          ),
                        ),
                      ),
                    ],
                  ),
                  );

                } else {
                  return const SizedBox(
                    width: 0.0,
                    height: 0.0,
                  );
                }
              }

              );
        } else if (snapshot.hasError) {
          return const Text("Sem objetivos");
        }
        // By default show a loading spinner.
        return const Text("Sem ");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromRGBO(72, 117, 223, 1.0), Color(0xffffffff)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )

          ),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Container(
                  height: 1000,
                  margin: const EdgeInsets.only(top: 10),
                  child: buildThis(),
                ),

              ],
            ),
          )),
    );
  }
}
