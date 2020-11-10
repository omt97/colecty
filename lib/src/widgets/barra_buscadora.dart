import 'package:colecty/src/search/search_delegate.dart';
import 'package:flutter/material.dart';

class BarraBuscadora extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.red,
      height: 60.0,
      padding: EdgeInsets.all(10),
      child: RaisedButton(
        elevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        highlightElevation: 0,
        hoverElevation: 0,
        shape: StadiumBorder(),
        color: Colors.grey[100],
        child: Row(
          children: <Widget>[
            Icon(Icons.search, color: Colors.deepPurple[700]),
            SizedBox(width: 10.0),
            Text('Buscar', style: TextStyle(color: Colors.black),)
          ]
        ),
        onPressed: (){
          showSearch(
            context: context, 
            delegate: DataSearch(),
            //query: 'Hola'
          );
        }),
    );
  }
}