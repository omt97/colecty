import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:flutter/material.dart';

class AplicacionPage extends StatelessWidget {

  final UserBloc ub = new UserBloc();

  static final routeName = 'applicacion';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            RaisedButton(
              child: Text('Lila'),
              onPressed: (){
                ub.color = 'lila';
              },
            ),
            RaisedButton(
              child: Text('Rojo'),
              onPressed: (){ub.color = 'rojo';},
            ),
            RaisedButton(
              child: Text('Marron'),
              onPressed: (){ub.color = 'marron';},
            ),
            RaisedButton(
              child: Text('Verde'),
              onPressed: (){ub.color = 'verde';},
            ),
            RaisedButton(
              child: Text('Azul'),
              onPressed: (){ub.color = 'azul';},
            ),
            RaisedButton(
              child: Text('Rosa'),
              onPressed: (){ub.color = 'rosa';},
            ),
          ],
        ),
      ),
    );
  }
}