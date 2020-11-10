import 'package:colecty/src/bloc/user_bloc.dart';
import 'package:colecty/src/util/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {

  final userBloc = new UserBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[100],
      child: Center(
        child: SpinKitChasingDots(
          color: getAppColor(userBloc.color, 500),
          size: 50.0,
        ),
      ),
    );
  }
}