import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unemindemaville/shared/colors.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Center(
          child: Column( children: <Widget>[
            Expanded(
              child:SpinKitChasingDots(color: appMainColor, size: 70.0,),
            ),
          ])
      ),
    );
  }
}class LoaderLight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Center(
          child: SpinKitChasingDots(color: appMainColor, size: 70.0,)
      ),
    );
  }
}
class LoaderWhiteBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      child: Center(
          child: Column( children: <Widget>[
            Expanded(
              child:SpinKitChasingDots(color: appMainColor, size: 70.0,),
            ),
          ])
      ),
    );
  }
}