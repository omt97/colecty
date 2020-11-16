import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/widgets/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  static var routeName = 'register';

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

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
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        elevation: 0,
        title: Text('Register to Colecty')
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
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
                obscureText: true,
                validator: (val) => val.length < 6 ? 'Enter password 6 character length' : null,
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                }
              ),
              SizedBox(height: 20),
              RaisedButton(
                color: Colors.deepPurple,
                child: Text('Register', style: TextStyle(color: Colors.white),),
                onPressed: () async{
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _userBloc.registerWithEmailAndPassword(email, password);
                    
                    if (result == null){
                      setState(() {
                        error = 'Please put a valid email';
                        loading = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
              TextButton(
                onPressed: (){Navigator.pop(context);}, 
                child: Text('Login', style: TextStyle(color: Colors.red),)
              ),
              SizedBox(height: 20),
              Text(error, style: TextStyle(color: Colors.red),)
            ]
          )
        )
      ),
    );
  }
}