import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/models/item_model.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {

  final CollectionModel collectionModel;

  ItemList ({@required this.collectionModel});

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {

  List<Item> _items;
  int _tengui;

  final coleccionesBloc = new ColeccionesBloc();

  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {

    _items = widget.collectionModel.tenguis;
    _tengui = widget.collectionModel.noFaltas;

    final _screenSize = MediaQuery.of(context).size;

    int numeroElementos = ((_screenSize.width)/60).truncate();

    return ListView.builder(
      itemCount: _obtenerListas(_items.length, numeroElementos),
      itemBuilder: (context, i){
        return Row(
          children: _getButtons(numeroElementos, _items, i)
          
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

  List<Widget> _getButtons(int numeroElementos, List<Item> items, int fila){
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

        margin: EdgeInsets.all(2.5),
        child: Stack(
          children: [
            _buttonItem(i + fila*numeroElementos, items[i + fila*numeroElementos], items[i + fila*numeroElementos].name),
            _cantidadItem(items[i + fila*numeroElementos].quantity)
            
            
          ],
        ),
      )
    );
    }
    elementos.add(Expanded(child: SizedBox(width: double.infinity,)));
    return elementos;
  }

  Widget _buttonItem(int i, Item item, String name){

    return ButtonTheme(
      minWidth: 50,
      height: 50,
      padding: EdgeInsets.all(2.5),
      child: new RaisedButton(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.deepPurple[300], width: 3.0)
        ),
        child: Center(child: Text(getNumeroName(name))),
        color: (item.quantity > 0) ? Colors.deepPurple[300] : Colors.transparent,
        textColor: (item.quantity > 0) ? Colors.white : Colors.deepPurple[300],
        onLongPress: (){
          setState(() {
            if (item.quantity > 0) coleccionesBloc.restarItemCantidad(widget.collectionModel, item, _tengui);
          });
        },
        onPressed: (){
          setState(() {
            coleccionesBloc.sumarItemCantidad(widget.collectionModel, item, _tengui);
          });
        },
      ),
    );
  }

  Widget _cantidadItem(int cantidad){
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
  }
}