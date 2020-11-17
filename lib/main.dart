import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/models/user_model.dart';
import 'package:colecty/src/pages/authentication/register.dart';
import 'package:colecty/src/pages/authentication/signin.dart';
import 'package:colecty/src/pages/home/collection_page.dart';
import 'package:colecty/src/pages/home/home_page.dart';
import 'package:colecty/src/pages/home/navigation_page.dart';
import 'package:colecty/src/pages/home/setting/acount_page.dart';
import 'package:colecty/src/pages/home/setting/aplicacion_page.dart';
import 'package:colecty/src/pages/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {

  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: _userBloc.userStream,
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'wrapper',
        routes: {
          Wrapper.routeName        : (BuildContext context) => Wrapper(),
          HomePage.routeName        : (BuildContext context) => HomePage(),
          NavigationPage.routeName  : (BuildContext context) => NavigationPage(),
          CollectionPage.routeName  : (BuildContext context) => CollectionPage(),
          SignIn.routeName  : (BuildContext context) => SignIn(),
          Register.routeName  : (BuildContext context) => Register(),
          AplicacionPage.routeName  : (BuildContext context) => AplicacionPage(),
          AcountPage.routeName  : (BuildContext context) => AcountPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.greenAccent
        )
      ),
    );
  }
}