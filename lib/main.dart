import 'package:capama_app/services/bloc.dart';
import 'package:flutter/material.dart';
import 'package:capama_app/utils/rutas.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

        /*
        Evita que la pantalla pueda rotar, por alguna razón la app
        inicia de forma horizontal, no supe porque asi que tuve que poner
        esto:
        https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait?rq=1
         */
        SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return ChangeNotifierProvider(
      create: (context)=> UsuarioProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: '/',
        routes: rutas(),
        theme: ThemeData(
          textTheme: TextTheme(
            headline1: TextStyle(fontFamily:"MPLUSRounded1c", fontSize: 14.0),
            headline2: TextStyle(fontFamily:"MPLUSRounded1c", fontSize: 14.0,color: Colors.white),
          ),
        ),
      ),
    );
  }
}