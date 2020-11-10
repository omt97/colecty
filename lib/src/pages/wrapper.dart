import 'package:colecty/src/models/user_model.dart';
import 'package:colecty/src/pages/authentication/signin.dart';
import 'package:flutter/material.dart';

import 'home/navigation_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  static final routeName = 'wrapper';

  

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);

    if (user != null){
      return NavigationPage();
    }else {
      return SignIn();
    }
    //return home or auth
    
  }
}