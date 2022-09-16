import 'package:biblioteca_flutter/modules/home/pages/home_page.dart';
import 'package:biblioteca_flutter/modules/login/pages/login_page.dart';
import 'package:biblioteca_flutter/modules/login/pages/sing_in_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntrarCadastroPage extends StatefulWidget {
  const EntrarCadastroPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntrarCadastroPageState();
}

class _EntrarCadastroPageState extends State<EntrarCadastroPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color.fromRGBO(72, 117, 223, 1.0), Color(0xffffffff)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )

        ),
        child:  ListView(
          children: <Widget>[


            Container(

              margin: const EdgeInsets.only(top: 20.0),
              height: 100,
              width: 50,
              child: Column(

                children: <Widget>[
                  Image.asset(
                    'assets/imagens/apitoBranco.png',
                    height: 90,
                  ),
                ],
              ),
            ),


            SizedBox(height: 50),
            Container(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'S I M U L A D O R   F I N A N C E I R O ',
                          style: TextStyle(
                             fontFamily: 'BebasNeue',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 30))
                    ],
                  ),
                )),
            SizedBox(height: 200),

            Container(
              width: screenSize.width,
             child: SizedBox(
                height:50, //height of button
                width:400, //width of button equal to parent widget
                child:ElevatedButton(

                child: Text(
                    'CRIAR UMA CONTA',
                    style: TextStyle(color: Colors.blue, fontSize: 20,fontFamily: 'BebasNeue',)),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(width:0.4, color:Colors.blue),
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SingInPage(),
                    ),
                  );
                },
              ),
             ),
              alignment: Alignment.center,
            ),
            SizedBox(height: 10 ),
            Container(
              width: screenSize.width,
              child: SizedBox(
                height:50, //height of button
                width:400, //width of button equal to parent widget
                child:ElevatedButton(

                  child: Text(
                      'FAZER O LOGIN',
                      style: TextStyle(color: Colors.white, fontSize: 20,fontFamily: 'BebasNeue',)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    side: BorderSide(width:0.1, color:Colors.white),
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ),
              alignment: Alignment.center,
            ),


          ],
        ),
      )

    );
  }
}
