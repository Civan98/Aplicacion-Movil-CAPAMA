import 'package:capama_app/database/database_conn.dart';
import 'package:capama_app/src/login/login_page.dart';
import 'package:flutter/material.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  TextEditingController _emailData = new TextEditingController();

  TextEditingController _numContratOrEmployedData = new TextEditingController();

  Conexion conexion = new Conexion();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();


  bool _enableBtn = false;

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Recuperar cuenta"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: _screenSize.height * 0.030,
              ),
              imagenReset(context),
              SizedBox(
                height: _screenSize.height * 0.030,
              ),
              form(context),
              SizedBox(
                height: _screenSize.height * 0.035,
              ),
              boton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget imagenReset(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
        child: Image(
      fit: BoxFit.contain,
      image: AssetImage("assets/img/reset_pass.png"),
      width: _screenSize.width * 1,
      height: _screenSize.height * 0.3,
    ));
  }

  Widget _email(BuildContext context) {
    RegExp expCorreo = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Correo electrónico",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _emailData,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "ej. pedro@gmail.com",
              suffixIcon: Icon(Icons.email_outlined),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
          validator: (data)
          {
            if(data.isEmpty)
            {
              return "Campo obligatorio.";
            }
            if(!expCorreo.hasMatch(_emailData.text))
            {
              return "Ingrese un email válido.";
            }
            return null;
          },
          ),
        ],
      ),
    );
  }

  Widget _numContratoOrNumEmployed(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Número de contrato o de empleado:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _numContratOrEmployedData,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              suffixIcon: Icon(Icons.person_outline),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
          validator: (data)
          {
            if(data.isEmpty)
            {
              return "Campo obligatorio.";
            }
            return null;
          },
          ),
        ],
      ),
    );
  }

  mensajeEnviado(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Text("Revise su bandeja de entrada"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  width: _screenSize.width * 0.5,
                  height: _screenSize.height * 0.2,
                  image: AssetImage("assets/img/email_send.png"),
                  fit: BoxFit.cover,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [botonDialog(context)],
                ),
              ],
            ),
          );
        });
  }

  Widget boton(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: _screenSize.width*0.26, vertical: _screenSize.height*0.032),
        child: Text(
          'Recuperar cuenta',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      color: Colors.blue,
      onPressed: _enableBtn ? null: () async {
        if(_formKey.currentState.validate())
        {
        
        setState(() => _enableBtn = !_enableBtn);
        bool p = await conexion.queryEmailUserReset(
            _emailData.text, _numContratOrEmployedData.text);
        // await Future.delayed(Duration(seconds: 3));
        if (p) {
          mensajeEnviado(context);
        } else {
           setState(() => _enableBtn = !_enableBtn);
          showSnackBar(context,"No se pudo validar, verifica tus datos");
        }
 
        }
      },
    );
  }

  Widget botonDialog(BuildContext context) {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 20.0),
        child: Text(
          'Volver',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      color: Colors.blue,
      onPressed: () {
        //Remueve todo lo de la pila y manda a la siguiente pantalla
        //No sé porque no me deja usar el "login" asi que use el MaterialPageRoute
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      },
    );
  }

   showSnackBar(BuildContext context, String text) {
    final snack = SnackBar(
      content: Text(text),
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }

  Widget form(BuildContext context) 
  {
    final _screenSize = MediaQuery.of(context).size;
    return Form(
      key:_formKey,
      child: Column(
        children: <Widget>[
             _email(context),
                SizedBox(
                  height: _screenSize.height * 0.050,
                ),
                _numContratoOrNumEmployed(context),
        ],
      ),
    );
  }
}
