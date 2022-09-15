import 'package:biblioteca_flutter/modules/home/pages/tabs/tab_home.dart';
import 'package:biblioteca_flutter/modules/home/pages/tabs/tab_investimento.dart';
import 'package:biblioteca_flutter/modules/home/pages/tabs/tab_usuario.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: const Color.fromRGBO(51, 51, 51, 1.0),
          appBar: AppBar(
            centerTitle: true,
            title: Text('simulador financeiro',
            ),

            backgroundColor: Colors.transparent,
            bottomOpacity: 0.0,
            elevation: 0.0,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              TabBar(
                indicatorColor: const Color.fromRGBO(255, 153, 51, 1.0),

                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.show_chart_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Expanded(child:
              TabBarView(children: [

                TabHome(),
                TabInvestimento(),
                TabUsuario(),



              ]),
              ),


            ],
          ),
        ));
  }
}
