import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/widgets/barra_buscadora.dart';
import 'package:colecty/src/widgets/collection_cards.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {

  static final routeName = 'home';
  final coleccionesBloc = new ColeccionesBloc();

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    coleccionesBloc.modificarFiltro('todas');

    return  Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.deepPurple[100],
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.deepPurple[100], Colors.white]
          )
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30.0),
            BarraBuscadora(),
            SizedBox(height: 0.0),
            Row(children: <Widget>[
              Expanded(child: SizedBox(width: double.infinity,)),
              IconButton(icon: Icon(Icons.filter_alt, color: Colors.deepPurple[700],), onPressed: (){
                _opcionesFilter(context);
              }),
              SizedBox(width: 10)
            ]),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: _screenSize.width,
              height: _screenSize.height - 213.0,
              child: CollectionCards(),
            )
          ],
        ),
      ),
    );
  }

  _opcionesFilter(BuildContext context, ){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Ordenar Por', style: TextStyle(color: Colors.deepPurple,),),
          content: Container(
            height: 250,
            child: Column(
              children: <Widget>[
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltro('todas');
                    Navigator.of(context).pop();
                  }, 
                  child: Text(
                    'Todos', 
                    style: TextStyle(color: coleccionesBloc.filtro == 'todas' ? Colors.deepPurple : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltro('favoritas');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Favoritas', 
                    style: TextStyle(color: coleccionesBloc.filtro == 'favoritas' ? Colors.deepPurple : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltro('asc');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Mas completa', 
                    style: TextStyle(color: coleccionesBloc.filtro == 'asc' ? Colors.deepPurple : Colors.grey),)),
                Divider(),
                TextButton(
                  onPressed: (){
                    coleccionesBloc.modificarFiltro('desc');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Menos completa', 
                    style: TextStyle(color: coleccionesBloc.filtro == 'desc' ? Colors.deepPurple : Colors.grey),)),

              ]
            ),
          )
        );
      }
    );
  }
}