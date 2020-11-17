import 'dart:async';

import 'package:colecty/src/models/user_model.dart';
import 'package:colecty/src/provider/auth.dart';
import 'package:colecty/src/provider/database.dart';

class UserBloc {

  static final UserBloc _singleton = new UserBloc._internal();

  final AuthProvider authProvider = new AuthProvider();

  String uid = '';
  String color = '';
  String email = '';

  factory UserBloc(){
    return _singleton;
  }

  UserBloc._internal();

  final _userController = StreamController<UserModel>.broadcast();

  Stream<UserModel> get userStream => _userController.stream;

  dispose(){
    _userController?.close();
  }

  Future<dynamic> loginAnon() async {

    UserModel user = await authProvider.signInAnon();
    _userController.sink.add(user);
    return user;

  }

  Future<dynamic> registerWithEmailAndPassword(String email, String password) async {

    UserModel user = await authProvider.registerWithEmailAndPassword(email, password);
    _userController.sink.add(user);
    uid = user.uid;
    color = user.color;
    email = user.email;
    return user;

  }

  Future<dynamic> loginWithEmailAndPassword(String email, String password) async {

    UserModel user = await authProvider.loginWithEmailAndPassword(email, password);
    _userController.sink.add(user);
    uid = user.uid;
    color = user.color;
    email = user.email;

    return user;

  }

  Future<dynamic> loginWithGoogle() async{
    UserModel user = await authProvider.loginGoogle();
    user.color = await DatabaseProvider(uid: user.uid).obtenerColor();
    _userController.sink.add(user);
    if (user != null){
      this.uid = user.uid;
      this.color = user.color;
      this.email = user.email;
    }

    return user;
  }

  Future logout() async {
    await authProvider.googleSignout();
    _userController.sink.add(null);
  }

  Future changeColor(String colorNuevo) async{
    this.color = colorNuevo;
    await DatabaseProvider(uid: this.uid).modificarColor(colorNuevo);
    _userController.sink.add(new UserModel(uid: this.uid, email: this.email, color: this.color));
  }

  void deleteAccount() {
    
  }

}