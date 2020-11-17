import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:flutter/material.dart';

class AplicacionPage extends StatefulWidget {

  static final routeName = 'applicacion';

  @override
  _AplicacionPageState createState() => _AplicacionPageState();
}

class _AplicacionPageState extends State<AplicacionPage> {
  final UserBloc ub = new UserBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getAppColor(ub.color, 50),
      appBar: AppBar(
          elevation: 0,
          backgroundColor: getAppColor(ub.color, 200),
          title: Text('Aplicacion', style: TextStyle(color: getAppColor(ub.color, 500)),)
        ),
      body: Container(
        child: Column(
          children: [
            Container(padding: EdgeInsets.all(20), child: Text('App Color', style: TextStyle(color: getAppColor(ub.color, 500), fontSize: 20),)),
            _getColor(Colors.deepPurple, 'Lila'),
            _getColor(Colors.red, 'Rojo'),
            _getColor(Colors.brown, 'Marron'),
            _getColor(Colors.green, 'Verde'),
            _getColor(Colors.blue, 'Azul'),
            _getColor(Colors.pink, 'Rosa'),
          ],
        ),
      ),
    );
  }

  Widget _getColor(Color color, String textColor){
    return Container(
      width: 100,
      child: RaisedButton(
        color: Colors.transparent,
        elevation: 0,
        child: Row(
          children: [
            Container(
              width: 10, 
              height: 10, 
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
              )
            ),
            SizedBox(width: 10),
            Text(textColor, style: TextStyle(color: (ub.color == textColor.toLowerCase()) ? getAppColor(ub.color, 500) : Colors.grey),),
          ],
        ),
        onPressed: (){
          setState(() {
            ub.changeColor(textColor.toLowerCase());
          });
        },
      ),
    );

  }
}