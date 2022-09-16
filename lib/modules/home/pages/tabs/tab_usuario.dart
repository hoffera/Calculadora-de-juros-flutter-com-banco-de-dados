import 'dart:convert';

import 'package:biblioteca_flutter/entities/usuario.dart';
import 'package:biblioteca_flutter/modules/login/pages/entrarcadastro_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/api.dart';

Usuario? usuarioData;

class TabUsuario extends StatefulWidget {
  const TabUsuario({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TabUsuario();
}

class _TabUsuario extends State<TabUsuario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Usuario usuario =
      Usuario(id: 0, nome: "", email: "", senha: "", confirmarSenha: "");
  late Future<Usuario> futureUsuario;

  @override
  void initState() {
    super.initState();
    futureUsuario = _fetchUsuario();
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (usuario.nome == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o nome!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (usuario.email == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe o e-mail!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (usuario.senha == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a senha!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (usuario.confirmarSenha == "") {
        Fluttertoast.showToast(
            msg: 'Por favor, informe a confirmação da senha!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else if (usuario.senha != usuario.confirmarSenha) {
        Fluttertoast.showToast(
            msg: 'As senhas não são iguais!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      } else {
        _editarUsuario();
      }
    }
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
      usuarioData = Usuario.fromJson(jsonResponse);

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

  void _editarUsuario() async {
    var id = usuarioData?.id;
    var url = '$baseURL/usuarios/$id';
    var body = '';
    if (usuario.senha != "") {
      body = json.encode({
        'nome': usuario.nome,
        'email': usuario.email,
        'senha': usuario.senha
      });
    } else {
      body = json.encode({'nome': usuario.nome, 'email': usuario.email});
    }
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('auth_token');
    Map<String, String> headers = {};
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = 'Bearer $token';
    try {
      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: 'Usuário Editado!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            fontSize: 20.0);
      } else {
        Map<String, dynamic> responseMap = json.decode(response.body);
        if (responseMap["message"].contains('ConstraintViolationException')) {
          Fluttertoast.showToast(
              msg: 'E-mail duplicado!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              fontSize: 20.0);
        } else {
          Fluttertoast.showToast(
              msg: 'Erro ao editar o usuário!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              fontSize: 20.0);
        }
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [const Color.fromRGBO(72, 117, 223, 1.0), Color(0xffffffff)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
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
                            text: 'Olá, ${usuarioData?.nome} tudo bem?',
                            style: TextStyle(color: Colors.white, fontSize: 25,fontFamily: 'BebasNeue',))
                      ],
                    ),
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'Email: ${usuarioData?.email}\n',
                            style: TextStyle(color: Colors.white, fontSize: 25,fontFamily: 'BebasNeue',))
                      ],
                    ),
                  )),

              Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text:
                            'Deseja Sair?',
                            style: TextStyle(color: Colors.white, fontSize: 25,fontFamily: 'BebasNeue',))
                      ],
                    ),
                  )),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: Text('Sair',
                      style: TextStyle(color: Colors.white, fontSize: 16,fontFamily: 'BebasNeue',)),
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
