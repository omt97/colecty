import 'dart:async';

import 'package:colecty/src/models/user_model.dart';
import 'package:colecty/src/provider/auth.dart';

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
    print(user.uid + ' registrado');
    uid = user.uid;
    color = user.color;
    email = user.email;
    return user;

  }

  Future<dynamic> loginWithEmailAndPassword(String email, String password) async {

    UserModel user = await authProvider.loginWithEmailAndPassword(email, password);
    _userController.sink.add(user);
    print('asa');
    if (user != null){
      uid = user.uid;
      color = user.color;
      email = user.email;
    }

    return user;

  }

  Future logout() async {
    await authProvider.signOut();
    _userController.sink.add(null);
  }

}