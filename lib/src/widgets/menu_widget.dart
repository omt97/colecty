import 'package:colecty/src/pages/home/home_page.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {


  

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/menu-img.jpg"),
                fit: BoxFit.cover
              )
            ),
          ),
          ListTile(
            leading: Icon(Icons.pages, color: Colors.deepPurple),
            title: Text('Home'),
            onTap: (){
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.deepPurple),
            title: Text('Settings'),
            onTap: (){
              //Navigator.pop(context);
              //Navigator.pushReplacementNamed(context, SettingsPage.routeName); //esto hace que la otra pagina sea principal
            },
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.deepPurple),
            title: Text('Information'),
            onTap: (){},
          ),
        ],
      ),
    );
  }
}