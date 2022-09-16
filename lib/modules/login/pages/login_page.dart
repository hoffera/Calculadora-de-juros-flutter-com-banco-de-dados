import 'dart:convert';
import 'package:biblioteca_flutter/entities/usuario.dart';
import 'package:biblioteca_flutter/config/api.dart';
import 'package:biblioteca_flutter/modules/home/pages/home_page.dart';
import 'package:biblioteca_flutter/modules/login/pages/sing_in_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Usuario usuario =
  Usuario(id: 0, nome: "", email: "", senha: "", confirmarSenha: "");

  void submit() {

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    if (usuario.email == "") {
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
      } else {
      login();
      }
    }
  }
  void login() async {
    const url = '$baseURL/authenticate';
    var body = json
        .encode({'username': usuario.email, 'password': usuario.senha});
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
        Fluttertoast.showToast(
            msg: 'E-mail e/ou senha incorretos!',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            fontSize: 20.0);
      }
    } on Object catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: const Color.fromRGBO(51, 51, 51, 1.0),
          title: const Text(
            'Esqueci a senha',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Para recuperar sua senha informe seu E-mail',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 100,
              child:  Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                      primary: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
            ),

          ],
        );
      },
    );
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
            builder: (context) => const HomePage(),
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color.fromRGBO(72, 117, 223, 1.0),
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
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
                    child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Olá, tudo bem?',
                          style: TextStyle(
                              fontFamily: 'BebasNeue',
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
                              text: 'Faça o seu login com seu \nE-Mail e senha.',
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
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white,
                     fontSize: 16),
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
                    style: TextStyle(color: Colors.white,
                     fontSize: 16),
                    onSaved: (String? value) {
                      usuario.senha = value!;
                    }),
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () {
                      _dialogBuilder(context);
                      // Respond to button press
                    },
                    child: Text(
                      "Esqueci minha senha",
                      style: TextStyle(color: Colors.white,
                        fontFamily: 'BebasNeue',fontSize: 20),
                    ),
                  ),
                  padding: EdgeInsets.zero,
                ),
                Container(
                  width: screenSize.width,
                  child: IconButton(
                    icon: const Icon(Icons.east_rounded, size: 50),
                    color: Colors.white,
                    onPressed:

                    submit,
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
