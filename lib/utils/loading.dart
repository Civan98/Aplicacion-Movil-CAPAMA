import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/*
Un Loading a scaffold completo, usable para pantallas de carga.
 */

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SpinKitRotatingCircle(
  color: Colors.white,
  size: 50.0,
)
      ),
    );
  }
}