import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/pages/home/home_page.dart';
import 'package:colecty/src/pages/home/setting/settings_page.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:colecty/src/widgets/create_collection.dart';

import 'package:flutter/material.dart';

class NavigationPage extends StatefulWidget {

  static final routeName = 'navigation';

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int currentIndex = 0;

  final coleccionesBloc = new ColeccionesBloc();
  final userBloc = new UserBloc();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _callPage(currentIndex),
      bottomNavigationBar: _crearBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        
        foregroundColor: Colors.white,
        hoverColor: getAppColor(userBloc.color, 700),
        splashColor: getAppColor(userBloc.color, 700),
        focusColor: getAppColor(userBloc.color, 700),
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {return CreateCollection(new CollectionModel(), false);}
          );
        },
      backgroundColor: getAppColor(userBloc.color, 700)
      ),
    );
  }

  

  Widget _callPage(int paginaActual) {

    switch(paginaActual){

      case 0: return HomePage();
      case 1: return Settings();

      default: return HomePage();

    }

  }

  Widget _crearBottomNavigationBar() {

    return BottomNavigationBar(
      unselectedItemColor: getAppColor(userBloc.color, 200),
      elevation: 0,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: currentIndex,
      selectedItemColor: getAppColor(userBloc.color, 700),
      onTap: (index){
        setState(() {
          currentIndex = index;
        });
      },
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home'
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings'
        )
      ]
    );

  }
}