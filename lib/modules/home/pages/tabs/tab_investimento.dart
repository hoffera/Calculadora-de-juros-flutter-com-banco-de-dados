import 'dart:convert';

import 'package:biblioteca_flutter/entities/investimento.dart';
import 'package:biblioteca_flutter/entities/objetivo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/api.dart';

bool criarCard = false;
bool isVisible2 = false;
String? myData;

class TabInvestimento extends StatefulWidget {
  const TabInvestimento({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabInvestimento();
}

class _TabInvestimento extends State<TabInvestimento> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<Investimento>> futureInvestimentos;
  late Objetivo objetivo = Objetivo(
      id: 0, nome: "", valorEntrada: "0", valorEstimado: "0", valorMensal: "0");

  @override
  void initState() {
    super.initState();
    futureInvestimentos = _mostrarInvest();
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (objetivo.nome == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o nome!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (objetivo.valorEstimado == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o valor estimado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (objetivo.valorEntrada == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o valor entrada!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (objetivo.tempoConclusao == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o tempo conclusao!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        futureInvestimentos =  _mostrarInvestimentos();
        setState(() {
          myData = "a";

        });
      }
    }
  }

  void _adicionarObjetivo(Objetivo objetivo) async {
    const url = '$baseURL/objetivos';
    var body = json.encode({
      'nome': objetivo.nome,
      'tempoConclusao': objetivo.tempoConclusao,
      'valorEstimado': objetivo.valorEstimado,
      'valorEntrada': objetivo.valorEntrada,
      'valorMensal': objetivo.valorMensal,


    });}


  Future<List<Investimento>> _mostrarInvestimentos() async {
    print(objetivo.nome);



    var url = '$baseURL/investimentos/getInvestimentosComPmt/${objetivo.tempoConclusao}/${objetivo.valorEntrada}/${objetivo.valorEstimado}';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((investmento) => Investimento.fromJson(investmento))
          .toList();
    } else {
      throw ('Sem investimentos');
    }
  }

  Future<List<Investimento>> _mostrarInvest() async {




    var url = '$baseURL/investimentos/getInvestimentosComPmt/1/0/0';
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Authorization"] = 'Bearer $token';
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse
          .map((investmento) => Investimento.fromJson(investmento))
          .toList();
    } else {
      throw ('Sem investimentos');
    }
  }

  Widget buildThis() {
    return FutureBuilder<List<Investimento>>(
      future: futureInvestimentos,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          List<Investimento> _investimento = snapshot.data!;
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
                            'Investimento: ${_investimento[index].investimento}\nRisco: ${_investimento[index].risco!.id!}\nTaxa: ${_investimento[index].rentabilidade}\nPmt: ${_investimento[index].pmt}',
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              color: const Color.fromRGBO(255, 153, 0, 1.0),
                              onPressed: (){ _adicionarObjetivo(objetivo);}
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        } else if (myData == "error") {
          return const Text("Sem investimentoss");
        }
        // By default show a loading spinner.
        return const CircularProgressIndicator();
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
                TextFormField(
                    decoration: const InputDecoration(
                      hintText: '',
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSaved: (String? value) {
                      objetivo.nome = value!;
                    }),

                TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '',
                      labelText: 'Tempo conclusao',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSaved: (String? value) {
                      objetivo.tempoConclusao = value!;
                    }),

                TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '',
                      labelText: 'Valor entrada',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSaved: (String? value) {
                      objetivo.valorEntrada = value!;
                    }),
                TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '',
                      labelText: 'Valor estimado',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSaved: (String? value) {
                      objetivo.valorEstimado = value!;
                    }),

                Container(
                  child: IconButton(
                      icon: const Icon(Icons.east_rounded, size: 50),
                      color: const Color.fromRGBO(255, 153, 0, 1.0),
                      onPressed:(){

                        isVisible2 = true;
                        submit();

                      }
                  ),
                  alignment: Alignment.topLeft,
                ),
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