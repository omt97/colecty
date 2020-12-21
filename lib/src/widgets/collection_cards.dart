import 'dart:io';

import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/pages/home/collection_page.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:colecty/src/widgets/create_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CollectionCards extends StatefulWidget {

  @override
  _CollectionCardsState createState() => _CollectionCardsState();
}

class _CollectionCardsState extends State<CollectionCards> {
  final collectionBloc = new ColeccionesBloc();

  final userBloc = new UserBloc();

  @override
  Widget build(BuildContext context) {


    final _screenSize = MediaQuery.of(context).size;

    return StreamBuilder<List<CollectionModel>>(
      stream: collectionBloc.collectionsStream, //cuando se modifique salta
      builder: (BuildContext context, AsyncSnapshot<List<CollectionModel>> snapshot) {

        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final colecciones = snapshot.data;

        if (colecciones.length == 0){
          return Center(
            child: Image.asset('assets/logo.png', color: getAppColor(userBloc.color, 50),)
          );
        }

        return GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.purple[700],
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: colecciones.length,
            itemBuilder: (context, i){
              CollectionModel cm = colecciones[i];
              return Column(
                children: [
                  SizedBox(height: 20.0),
                  Card(
                    color: Colors.grey[100],
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: InkWell(
                      onTap: () {
                        collectionBloc.obtenerColeccion(colecciones[i]);
                        Navigator.pushNamed(context, CollectionPage.routeName, arguments: colecciones[i].title);
                      },
                      onLongPress: (){
                        //_deleteOption(context, colecciones[i].uid);
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {return CreateCollection(cm, true);}
                        );
                      },
                      child: Row(
                        children: [
                          _imagenColeccion(colecciones[i].title, colecciones[i].photo),
                          _infoColeccion(_screenSize.width, colecciones[i]),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 0.0)
                ],
              );
            }
          ),
        );
      }
    );
  }

  Widget _imagenColeccion(String title, String photo){
    return Container(
      decoration: BoxDecoration(
        color: getAppColor(userBloc.color, 50),
        borderRadius: BorderRadius.circular(20.0)
      ),
      height: 150.0,
      width: 150.0,
      padding: EdgeInsets.all(30.0),
      
      child: Hero(
        tag: title,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0), 
          child: _getImagen(photo),
          ),
        ),
    );
  }

  Widget _infoColeccion(double width, CollectionModel collectionModel){

    int textMax = ((width - 235)/18).truncate();// .round();

    print(textMax);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
      width: width - 228.0,
      height: 150,
      padding: EdgeInsets.only(bottom: 30.0, top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                collectionModel.title.length > (textMax + 2) ? collectionModel.title.substring(0, textMax + 2) + '...' :  collectionModel.title,
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              Expanded(child: SizedBox(width: double.infinity,)),
              IconButton(
                iconSize: 15,
                padding: EdgeInsets.all(2),
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                //splashColor: Colors.transparent,
                splashRadius: 15,
                icon: Icon(Icons.favorite, color: collectionModel.favourite ? getAppColor(userBloc.color, 500) : Colors.grey,), 
                onPressed: (){
                  collectionModel.favourite 
                    ? collectionBloc.coleccionFavorita(collectionModel.uid, false)
                    : collectionBloc.coleccionFavorita(collectionModel.uid, true);
                })
            ],
          ),
          Expanded(child: SizedBox(width: double.infinity,)),

          Text('Cantidad: ${collectionModel.noFaltas}/${collectionModel.total}' , style: TextStyle(color: Colors.grey[700], fontSize: 12)),
          Expanded(child: SizedBox(width: double.infinity,)),
          LinearPercentIndicator(
            width: width - 228,
            lineHeight: 14.0,
            percent: collectionModel.porcentage,
            backgroundColor: Colors.grey,
            progressColor: Colors.lightGreen[300],
          )
        ]
      ),
    );

  }

  Image _getImagen(String photo) {
    try{
      return Image.file(File(photo), fit: BoxFit.cover,);
    } catch (e) {
      return Image.asset('assets/logo.png', fit: BoxFit.cover);
    }

  }
}