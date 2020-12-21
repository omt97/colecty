import 'dart:io';

import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/models/item_model.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:colecty/src/widgets/edit_item.dart';
import 'package:flutter/material.dart';

class ItemInfoList extends StatefulWidget {

  final CollectionModel collectionModel;

  ItemInfoList ({@required this.collectionModel});

  @override
  _ItemInfoListState createState() => _ItemInfoListState();
}

class _ItemInfoListState extends State<ItemInfoList> {

  List<Item> _items;
  int _tengui;
  String _photoCollection;
  bool _modificar;

  final coleccionesBloc = new ColeccionesBloc();
  final userBloc = new UserBloc();

  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {

    _items = widget.collectionModel.tenguis;
    _tengui = widget.collectionModel.noFaltas;
    _photoCollection = widget.collectionModel.photo;
    _modificar = widget.collectionModel.modificable;

    final _screenSize = MediaQuery.of(context).size;

    return ListView.builder(
      itemCount: _obtenerListas(_items.length, 2),
      itemBuilder: (context, i){
        return Row(
          children: _getButtons(2, _items, i, _screenSize.width)
          
        );
      }
    );
  }

  int _obtenerListas(int items, int elementos){

    if (items/elementos > (items/elementos).truncate()) {
      return (items/elementos).truncate() + 1;
    } else {
      return (items/elementos).truncate();
    }

  }

  List<Widget> _getButtons(int numeroElementos, List<Item> items, int fila, double width){
    List<Widget> elementos = [];

    var elementosFila = numeroElementos;

    var nuevaLista = items.getRange(numeroElementos*fila, items.length);
    if (numeroElementos > nuevaLista.length) elementosFila = nuevaLista.length;

    //print(items.length);

    //print(width.toString());
    elementos.add(Expanded(child: SizedBox(width: double.infinity,)));
    for (int i = 0; i < elementosFila; ++i){

      //print(items[i + fila*numeroElementos].position);

      elementos.add(Container(

        margin: EdgeInsets.only(bottom: 14),
        child: _buttonItem(i + fila*numeroElementos, items[i + fila*numeroElementos], items[i + fila*numeroElementos].name, width),

        ),
      );
      elementos.add(Expanded(child: SizedBox(width: double.infinity,)));
    }
    //elementos.add(Expanded(child: SizedBox(width: double.infinity,)));
    return elementos;
  }

  Widget _buttonItem(int i, Item item, String name, double width){

    return new GestureDetector(
      onLongPress: (){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {return EditItem(item, widget.collectionModel);}
        );
      },
      child: Container(
        width: width/2 - 10,
        height: 260,
        padding: EdgeInsets.all(2.5),
        //elevation: 0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: getAppColor(userBloc.color, 200),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: width/2 - 10, 
              width: width/2 - 10, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0), 
                child: item.photo != null 
                  ? Image.file(File(item.photo), fit: BoxFit.cover) 
                  : (_photoCollection != null)
                    ? Opacity(
                      opacity: 0.5,
                      child: Image.file(File(_photoCollection), fit: BoxFit.cover,))
                    : Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover)
            )),
            Expanded(child: SizedBox(height: double.infinity,)),
            Container(child: _infoItem(name, item ),)
          ],
        ),

      ),
    );
  }

  Widget _infoItem(String name, Item item){

    return Column(
      children: <Widget>[
        Text(getNameSinNumero(name), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
        Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.remove_circle, size: 15,), 
              onPressed: 
                (item.quantity > 0) 
                ? (_modificar) 
                  ? () async{
                    await coleccionesBloc.changeModificable(false, widget.collectionModel);
                    if (item.quantity > 0) await coleccionesBloc.restarItemCantidad(widget.collectionModel, item, _tengui);
                    await coleccionesBloc.changeModificable(true, widget.collectionModel);
                  }
                  : null 
                : null, color: getAppColor(userBloc.color, 700)
            ),
            Expanded(child: SizedBox(width: double.infinity,)),
            Text(item.quantity.toString()),
            Expanded(child: SizedBox(width: double.infinity,)),
            IconButton(icon: Icon(Icons.add_circle, size: 15,), 
              onPressed: (_modificar) 
                  ? () async{
                    await coleccionesBloc.changeModificable(false, widget.collectionModel);
                    await coleccionesBloc.sumarItemCantidad(widget.collectionModel, item, _tengui);
                    await coleccionesBloc.changeModificable(true, widget.collectionModel);
                  }
                  : null
              , color: getAppColor(userBloc.color, 700),
            )
          ],
        )

      ],
    );

  }

  /*Widget _cantidadItem(int cantidad){
    if (cantidad > 0) {
      return Positioned.fill(
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          child: Center(child: Text(cantidad.toString(), style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),)),
          height: 23, 
          width: 23, 
          decoration: BoxDecoration(
            color: Colors.red, 
            borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );
    } else return Container();
  }*/
}