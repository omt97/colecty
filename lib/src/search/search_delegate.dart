

import 'dart:io';

import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/pages/home/collection_page.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate{

  final collectionBloc = new ColeccionesBloc();

  String seleccion = '';
  final collectionModel = new CollectionModel();

  final coleccionesBloc = new ColeccionesBloc();
  final userBloc = new UserBloc();


  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: getAppColor(userBloc.color, 400),
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      primaryColorBrightness: Brightness.light,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear), 
          onPressed: (){
            query = '';

          }
        ),

      ];
    }
  
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ), 
      onPressed: (){
        close(context, null);
      }
    );
  }
  
  @override
  Widget buildResults(BuildContext context) {
     return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: getAppColor(userBloc.color, 500),
        child: Text(seleccion)
      ),
    );
  }
  
  @override
  Widget buildSuggestions(BuildContext context) {

    coleccionesBloc.obtenerColeccionesSearch(query);


    return StreamBuilder(
      stream: coleccionesBloc.collectionsStreamSearch,
      builder: (BuildContext context, AsyncSnapshot<List<CollectionModel>> snapshot){
        if (snapshot.hasData){
          
          List<CollectionModel> colecciones = snapshot.data;


          return ListView.builder(
            
            itemCount: colecciones.length,
            itemBuilder: (BuildContext context, int i) {
              return InkWell(
                onTap: (){
                  collectionBloc.obtenerColeccion(colecciones[i]);
                  Navigator.pushNamed(context, CollectionPage.routeName, arguments: colecciones[i].title);
                  //close(context, null);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: getAppColor(userBloc.color, 50)
                  ),
                  child: ListTile(
                    leading: _imagenColeccion(colecciones[i].title, colecciones[i].photo),
                    title: Text(colecciones[i].title),
                    //subtitle: ,
                  ),
                ),
              );
            },
          );

        } else {
          return Container();
        }
      },
    );
  }

  Widget _imagenColeccion(String title, String photo){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0)
      ),
      height: 50.0,
      width: 50.0,
      
      child: Hero(
        tag: title,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0), 
          child:Image.file(
            File(photo),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }




}