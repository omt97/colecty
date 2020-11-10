import 'package:colecty/src/models/user_model.dart';
import 'package:colecty/src/provider/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthProvider {


  FirebaseAuth _auth;

  UserModel _userFromFirebaseUser(User user){
    return user != null ? UserModel(uid: user.uid) : null;
  }

  AuthProvider(){
    _iniciarFirebase();
  }
  
  _iniciarFirebase() async{
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
  }

  //sign in anon
  Future signInAnon() async{
    
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }

  }

  //sign in with email
  Future loginWithEmailAndPassword(String email, String password) async{

    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email
  Future<UserModel> registerWithEmailAndPassword(String email, String password) async{

    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      //crear nueva entrada db
      await DatabaseProvider(uid: user.uid).updateUserData(user.email);

      print(user.email);

      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async{
    
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }

  }
}

