import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/pages/home/setting/aplicacion_page.dart';
import 'package:colecty/src/util/utils.dart';
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
      backgroundColor: getAppColor(_userBloc.color, 100),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: getAppColor(_userBloc.color, 200),
          title: Text('Settings', style: TextStyle(color: getAppColor(_userBloc.color, 500)),)
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _createButton(
              icono: Icon(Icons.account_box, color: getAppColor(_userBloc.color, 500)), 
              texto:'Cuenta', 
              onPressed: () async{
                
              },
            ),
            Divider(thickness: 1.5,),
            _createButton(
              icono: Icon(Icons.app_settings_alt, color: getAppColor(_userBloc.color, 500)), 
              texto:'Aplicacion', 
              onPressed: () async{
                Navigator.pushNamed(context, 'applicacion');
              },
            ),
            Divider(thickness: 1.5,),
            _createButton(
              icono: Icon(Icons.logout, color: getAppColor(_userBloc.color, 500)), 
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
            Text(texto, style: TextStyle(color: getAppColor(_userBloc.color, 500)))
          ],
        ),
      ),
      onPressed: onPressed
    );

  }
}