import 'package:flutter/material.dart';
import 'package:location/location.dart';

class PrincipalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  final _screenSize = MediaQuery.of(context).size; 
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imagenLogo(context),
            SizedBox(height: _screenSize.height*0.050,),
            footer(context),
          ],
        ),
      ),
    );
  }
  //Este se encarga de mostrar la imagen de capama
  Widget imagenLogo(BuildContext context) {
        var location = new Location(); 
        location.requestService();
    final _screenSize = MediaQuery.of(context).size;
    return Container(
        child: Image(
      fit: BoxFit.contain,
      image: AssetImage("assets/img/icon.png"),
      width: _screenSize.width * 0.6,
      height: _screenSize.height * 0.3,
    ));
  }
//Crea el boton con los estilos
  Widget boton(BuildContext context) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 15.0),
        child: Text(
          'Ingresar',
          style:Theme.of(context).textTheme.headline2,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      color: Colors.blue,
      onPressed: () {
        Navigator.pushNamed(context, "login");
      },
    );
  }

//Texto que se muestra abajo del boto
  Widget textoLogin(BuildContext context) {
    return GestureDetector(
      //Text.rich permite crear un texto compuesto, como un Row.
      child: Text.rich(
        TextSpan(text:"No tienes una cuenta?",
        style:Theme.of(context).textTheme.headline1,
        children: <TextSpan>[
          TextSpan(text: " Crea una.",
            style:TextStyle(
              decoration: TextDecoration.underline
          ) ),
        ],
        ),
      ),

      onTap: (){
        Navigator.pushNamed(context, "registro");
      }
    );
  }
//Junta el boton y el texto dentro de una columna para poder darle una altura respecto al bóton
  Widget footer(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        boton(context),
        SizedBox(height: _screenSize.height*0.050,),
        textoLogin(context),
      ],
    );
  }
}
