import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.deepPurple[200],
          title: Text('Settings', style: TextStyle(color: Colors.deepPurple),)
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Divider(thickness: 1.5, color: Colors.deepPurple,),
            _createButton(
              icono: Icon(Icons.account_box, color: Colors.deepPurple), 
              texto:'Cuenta', 
              onPressed: () async{
                
              },
            ),
            Divider(thickness: 1.5,),
            _createButton(
              icono: Icon(Icons.app_settings_alt, color: Colors.deepPurple), 
              texto:'Aplicacion', 
              onPressed: () async{
                
              },
            ),
            Divider(thickness: 1.5,),
            _createButton(
              icono: Icon(Icons.logout, color: Colors.deepPurple), 
              texto:'Log out', 
              onPressed: () async{
                await _userBloc.logout();
              },
            ),
            
          ],
        ),
    );
  }

  Widget _createButton({Icon icono, String texto, Function onPressed}){

    return TextButton(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            icono,
            SizedBox(width: 10,),
            Text(texto, style: TextStyle(color: Colors.deepPurple))
          ],
        ),
      ),
      onPressed: onPressed
    );

  }
}