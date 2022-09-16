import 'dart:convert';

import 'package:biblioteca_flutter/config/api.dart';
import 'package:biblioteca_flutter/entities/usuario.dart';
import 'package:biblioteca_flutter/modules/home/pages/home_page.dart';
import 'package:biblioteca_flutter/modules/login/pages/entrarcadastro_page.dart';
import 'package:biblioteca_flutter/modules/login/pages/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SingInPage extends StatefulWidget {
  const SingInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Usuario usuario = Usuario(id: 0, nome: "", email: "", senha: "", confirmarSenha: "");

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
        criarConta();
      }
    }
  }

  void criarConta() async {


    const url = '$baseURL/usuarios/criar';
    var body = json.encode(
        {'nome': usuario.nome, 'email': usuario.email, 'senha': usuario.senha});
    try {
      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      Map<String, dynamic> responseMap = json.decode(response.body);
      if (response.statusCode == 200) {
        final preferences = await SharedPreferences.getInstance();
        await preferences.setString('auth_token', responseMap["token"]);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        if (responseMap["message"].contains('EMAIL_DUPLICADO')) {
          Fluttertoast.showToast(
              msg: 'E-mail duplicado!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              fontSize: 20.0);
        } else {
          Fluttertoast.showToast(
              msg: 'Erro ao inserir o usuário!',
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
    final Size screenSize = MediaQuery.of(context).size;
    Future.delayed(Duration.zero, () async {
      await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
      final preferences = await SharedPreferences.getInstance();
      final token = preferences.getString('auth_token');
      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(72, 117, 223, 1.0),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      backgroundColor: const Color.fromRGBO(30, 30, 30, 1.0),
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
                    child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Criar conta',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30))
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
                                  'Informe seus dados abaixo para \ncontinuar.',
                              style: TextStyle(
                                  fontFamily: 'BebasNeue',
                                  color: Colors.white,
                                  fontSize: 20))
                        ],
                      ),
                    )),
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: '',
                      labelText: 'Nome Completo',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white,),
                    onSaved: (String? value) {
                      usuario.nome = value!;
                    }),
                TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: '',
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSaved: (String? value) {
                      usuario.email = value!;
                    }),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '',
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSaved: (String? value) {
                      usuario.senha = value!;
                    }),
                TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '',
                      labelText: 'Confirmar Senha',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    onSaved: (String? value) {
                      usuario.confirmarSenha = value!;
                    }),
                Container(
                  width: screenSize.width,
                  child: IconButton(
                    icon: const Icon(Icons.east_rounded, size: 50),
                    color: Colors.white,
                    onPressed: submit,
                  ),
                  alignment: Alignment.topLeft,
                ),
                Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.public,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: " HELLOSAKS.COM",
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          )),
    );
  }
}
