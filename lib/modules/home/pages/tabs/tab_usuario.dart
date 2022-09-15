import 'dart:convert';

import 'package:biblioteca_flutter/entities/usuario.dart';
import 'package:biblioteca_flutter/modules/login/pages/entrarcadastro_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../config/api.dart';


class TabUsuario extends StatefulWidget {
  const TabUsuario({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabUsuario();
}

Future<List<Usuario>> _fetchUsuarios() async {
  const url = '$baseURL/usuarios';
  final preferences = await SharedPreferences.getInstance();
  final token = preferences.getString('auth_token');
  Map<String, String> headers = {};
  headers["Authorization"] = 'Bearer $token';
  final response = await http.get(Uri.parse(url), headers: headers);
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    return jsonResponse.map((usuario) => Usuario.fromJson(usuario)).toList();
  } else {
    Fluttertoast.showToast(
        msg: 'Erro ao listar os usuarios',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        fontSize: 20.0
    );
    throw('Sem Usuários');
  }
}

class _TabUsuario extends State<TabUsuario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future <List<Usuario>> futureUsuarios;


  @override
  void initState() {
    super.initState();
    futureUsuarios = _fetchUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: ListView(
            children: <Widget>[



              Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Olá, tudo bem?\nEdite seus dados pessoas',
                            style: TextStyle(color: Colors.white, fontSize: 20))
                      ],
                    ),
                  )),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '',
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '',
                  labelText: 'E-mail',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '',
                  labelText: 'Senha',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '',
                  labelText: 'Confirmar Senha',
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: TextStyle(color: Colors.white),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'Sua senha deve conter, no mínimo, 6\ndígitos, incluindo números e letras\nminúsculas.',
                            style: TextStyle(color: Colors.white, fontSize: 15))
                      ],
                    ),
                  )),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: Text('Editar',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: const Color.fromRGBO(255, 153, 51, 1.0),
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: Text('Sair',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.transparent,
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  onPressed: () async {
                    final preferences = await SharedPreferences.getInstance();
                    await preferences.remove('auth_token');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EntrarCadastroPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
