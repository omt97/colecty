import 'package:colecty/src/bloc/colecciones_bloc.dart';
import 'package:colecty/src/models/coleccion_model.dart';
import 'package:colecty/src/models/item_model.dart';
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

  final coleccionesBloc = new ColeccionesBloc();

  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {

    _items = widget.collectionModel.tenguis;
    _tengui = widget.collectionModel.noFaltas;

    //final _screenSize = MediaQuery.of(context).size;

    //int numeroElementos = ((_screenSize.width)/60).truncate();

    return ListView.builder(
      itemCount: _obtenerListas(_items.length, 2),
      itemBuilder: (context, i){
        return Row(
          children: _getButtons(2, _items, i)
          
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

        margin: EdgeInsets.only(bottom: 14),
        child: _buttonItem(i + fila*numeroElementos, items[i + fila*numeroElementos], items[i + fila*numeroElementos].name),

        ),
      );
      elementos.add(Expanded(child: SizedBox(width: double.infinity,)));
    }
    //elementos.add(Expanded(child: SizedBox(width: double.infinity,)));
    return elementos;
  }

  Widget _buttonItem(int i, Item item, String name){

    return new GestureDetector(
      onLongPress: (){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {return EditItem(item, widget.collectionModel);}
        );
      },
      child: Container(
        width: 175,
        height: 250,
        padding: EdgeInsets.all(2.5),
        //elevation: 0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.deepPurple[200],
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 175, 
              width: 175, 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0), 
                child: Image(image: AssetImage(item.photo), 
                fit: BoxFit.cover,
            ))),
            Expanded(child: SizedBox(height: double.infinity,)),
            Container(child: _infoItem(name, item ),)
          ],
        ),
        
        //textColor: (cantidad > 0) ? Colors.white : Colors.deepPurple[300],
        //onLongPress: null,
        //onPressed: null,
      ),
    );
  }

  Widget _infoItem(String name, Item item){

    return Column(
      children: <Widget>[
        Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
        Row(
          children: <Widget>[
            IconButton(icon: Icon(Icons.remove_circle, size: 15,), 
              onPressed: (item.quantity > 0) ? () {if (item.quantity > 0) coleccionesBloc.restarItemCantidad(widget.collectionModel, item, _tengui);} : null, color: Colors.deepPurple[700]
            ),
            Expanded(child: SizedBox(width: double.infinity,)),
            Text(item.quantity.toString()),
            Expanded(child: SizedBox(width: double.infinity,)),
            IconButton(icon: Icon(Icons.add_circle, size: 15,), 
              onPressed: (){coleccionesBloc.sumarItemCantidad(widget.collectionModel, item, _tengui);}, color: Colors.deepPurple[700],
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