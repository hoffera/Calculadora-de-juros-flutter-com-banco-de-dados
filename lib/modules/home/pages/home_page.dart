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
          backgroundColor: const Color.fromRGBO(72, 117, 223, 1.0),
          appBar: AppBar(
            toolbarHeight: 30,
            centerTitle: true,
            title: Center(
              child: Wrap(
                direction: Axis.horizontal  ,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [

                  Text("S I M U L A D O R   F I N A N C E I R O ",style: const TextStyle(
                      fontFamily: 'BebasNeue',
                      fontSize: 20  ,

                      color: Colors.white),),



                  const Padding(padding: EdgeInsets.only(top: 10)),
                ],
              ),
            ),

            backgroundColor: const Color.fromRGBO(72, 117, 223, 1.0),
            bottomOpacity: 0.0,
            elevation: 0.0,
            automaticallyImplyLeading: false,
          ),
          body: Column(
            children: [
              TabBar(
                indicatorColor: Colors.white,

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
