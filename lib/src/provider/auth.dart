import 'package:colecty/src/models/user_model.dart';
import 'package:colecty/src/provider/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider {


  FirebaseAuth _auth;
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  UserModel _userFromFirebaseUser(User user){
    print('imprimir uid: ' + user.uid.toString());
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

  //login google
  Future<UserModel> loginGoogle() async {
    try{
      print('abc');
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      print('imprimir email account: ' + googleSignInAccount.email.toString());
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      print('imprimir email token: ' + googleSignInAuthentication.idToken.toString());
      print('imprimir email accestoken: ' + googleSignInAuthentication.accessToken.toString());

      AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken, 
        accessToken: googleSignInAuthentication.accessToken
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      print('imprimir email account: ' + result.user.email.toString());
      User _user = result.user;

      bool existe = await DatabaseProvider(uid: _user.uid).existUser();

      //crear nueva entrada db
      if (!existe) await DatabaseProvider(uid: _user.uid).updateUserData(_user.email);

      return _userFromFirebaseUser(_user);
    }catch (e){
      return null;
    }

    
  }

  //sing out google
  Future<void> googleSignout() async {
    await _auth.signOut().then((value) {
      _googleSignIn.signOut();

    });
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

