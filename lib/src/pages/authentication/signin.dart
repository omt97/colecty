import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/widgets/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  static var routeName = 'signin';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  //final AuthProvider _authProvider = AuthProvider();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  final UserBloc _userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {

    final circulo = new Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.deepPurple[300],
        borderRadius: BorderRadius.circular(100)
      )
    );

    final circulito = new Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        color: Colors.deepPurple[300],
        borderRadius: BorderRadius.circular(100)
      )
    );

    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.deepPurple[400],
      /*appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 0,
        title: Text('Sign in to Colecty')
      ),*/
      body: Stack(
        children: [
          Positioned(
            top: 150,
            right: 70,
            child: circulo
          ),
          Positioned(
            top: 300,
            right: -40,
            child: circulo
          ),
          Positioned(
            top: -5,
            left: 20,
            child: circulo
          ),
          Positioned(
            bottom: 60,
            right: 20,
            child: circulo
          ),
          Positioned(
            bottom: 250,
            left: 20,
            child: circulo
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: circulito
          ),
          Positioned(
            bottom: -10,
            left: 120,
            child: circulito
          ),
          Positioned(
            bottom: 150,
            left: 100,
            child: circulito
          ),
          Positioned(
            top: 250,
            left: 20,
            child: circulito
          ),
            
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 100),
                  Image(image: AssetImage('assets/logo.png'), width: 150,),
                  SizedBox(height: 50),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0)
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : 'Enter email',
                    onChanged: (val){
                      setState(() {
                        email = val;
                      });
                    }
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2.0)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0)
                      ),
                    ),
                    validator: (val) => val.length < 6 ? 'Enter password 6 character length' : null,
                    obscureText: true,
                    onChanged: (val){
                      setState(() {
                        password = val;
                      });
                    }
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    color: Colors.deepPurple,
                    child: Text('Log in', style: TextStyle(color: Colors.white),),
                    onPressed: () async{
                      if(_formKey.currentState.validate()){
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _userBloc.loginWithEmailAndPassword(email, password);
                        print(result);
                        if (result == null){
                          setState(() {
                            error = 'Please put a valid email';
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () { Navigator.pushNamed(context, 'register');}, 
                    child: Text('Regiser', style: TextStyle(color: Colors.red),)
                  ),
                  SizedBox(height: 20),
                  Text(error, style: TextStyle(color: Colors.red),),
                  Container(
                    height: 45,
                    width: 185, 
                    child: RaisedButton(
                      color: Colors.white,
                      elevation: 0,
                      focusElevation: 0,
                      disabledElevation: 0,
                      highlightElevation: 0,
                      hoverElevation: 0,
                      shape: StadiumBorder(),
                      child: Row( 
                        children: <Widget>[
                          Image(image: AssetImage('assets/logoGoogle.png'), width: 20,),
                          Expanded(child: SizedBox(width: double.infinity,)),
                          Text('Sign in with Google')
                        ]
                      ),
                      onPressed: ()async{
                        setState(() {
                          loading = true;
                        });
                        dynamic result = await _userBloc.loginWithGoogle();
                        print(result == null);
                        setState(() {
                          loading = false;
                        });
                      }
                    ),
                  )
                ]
              )
            )
          ),

          
        ],
      ),
    );
  }
}