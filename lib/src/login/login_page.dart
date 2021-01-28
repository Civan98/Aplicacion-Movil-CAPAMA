import 'package:capama_app/database/database_conn.dart';
import 'package:capama_app/models/usuario_model.dart';
import 'package:capama_app/src/employee/employee_welcome_page.dart';
import 'package:location/location.dart';
import 'package:capama_app/src/user/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Conexion prueba = new Conexion();
  final _formKey = GlobalKey<FormState>();
  String _correo;
  String _pass;
  bool _enable = false;
  bool _seepass = true;
  bool _isWorker = false;
  var location = new Location();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Iniciar sesión"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          SizedBox(
            height: _screenSize.height * 0.02,
          ),
          imageLogin(context),
          SizedBox(
            height: _screenSize.height * 0.030,
          ),
          formulario(context, pr),
          SizedBox(height: _screenSize.height * 0.05),
          textoRecuperar(context),
        ]),
      ),
    );
  }

  Widget formulario(BuildContext context, pr) {
    final _screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _email(context),
          SizedBox(
            height: _screenSize.height * 0.03,
          ),
          _password(context),
          SizedBox(
            height: _screenSize.height * 0.01,
          ),
          switchWorker(),
          SizedBox(
            height: _screenSize.height * 0.05,
          ),
          boton(context, pr),
        ],
      ),
    );
  }

  Widget switchWorker() {
    return SwitchListTile(
      secondary: Icon(Icons.work_rounded),
      title: Text(
        "Soy empleado",
        style: TextStyle(fontFamily: "MPLUSRounded1c", color: Colors.black45),
      ),
      value: _isWorker,
      onChanged: (value) {
        setState(() {
          _isWorker = !_isWorker;
        });
      },
    );
  }

  Widget imageLogin(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
        child: Image(
      fit: BoxFit.contain,
      image: AssetImage("assets/img/login.png"),
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
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "ej. ejemplo@ejemplo.com",
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Este campo es obligatorio";
              }
              if (!expCorreo.hasMatch(value)) {
                return "Esto no es un correo válido";
              }
              _correo = value;
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _password(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Contraseña:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: _seepass ? true : false,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Contraseña",
              suffixIcon: IconButton(
                  icon: _seepass
                      ? Icon(Icons.remove_red_eye_outlined)
                      : Icon(Icons.lock),
                  onPressed: () {
                    setState(() {
                      _seepass = !_seepass;
                    });
                  }),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "Este campo es obligatorio";
              }
              if (value.length < 2) {
                return "La contraseña es más grande";
              }
              _pass = value;
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget boton(BuildContext context, ProgressDialog pr) {
    final _screenSize = MediaQuery.of(context).size;
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _screenSize.width * 0.32,
            vertical: _screenSize.height * 0.024),
        child: Text(
          'Ingresar',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0.0,
      color: Colors.blue,
      onPressed: _enable
          ? null
          : () async {
              bool existEmail = true;
              print("$_correo");
              // si el formulario es correcto, habilitar el botón de ingresar
              if (_formKey.currentState.validate()) {
                setState(() => _enable = true);
                if (_isWorker) {
                  await pr.show();
                  if (!(await prueba.queryEmailWorker(_correo))) {
                    existEmail = false;
                  }
                  if (existEmail) {
                    if (await prueba.queryLoginWorker(
                        _correo, _pass, context)) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => EmployeeWelcome()),
                          (Route<dynamic> route) => false);
                    } else {
                      pr.hide();
                      setState(() => _enable = false);
                      showSnackBar(context, "Las credenciales no son válidas");
                    }
                  } else {
                    setState(() => _enable = false);
                    await pr.hide();
                    showSnackBar(
                        context, "El correo de empleado no está registrado");
                  }
                } else {
                  if (!(await prueba.queryEmailUser(_correo))) {
                    setState(() => _enable = false);
                    await pr.show();
                    existEmail = false;
                  }
                  // aquí se realizaban 2 peticiones a la bd, lo cual no es óptimo
                  // if (await prueba.queryEmailUser(_correo))
                  if (existEmail) {
                    await pr.show();
                    pr.hide();
                    print("Datos: $_correo y $_pass");

                    if (await prueba.queryLogin(_correo, _pass, context)) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => WelcomePage()),
                          (Route<dynamic> route) => false);
                    } else {
                      pr.hide();
                      setState(() => _enable = false);
                      showSnackBar(context, "Las credenciales no son válidas");
                    }
                  } else {
                    pr.hide();
                    showSnackBar(context, "El correo no está registrado");
                  }
                }
              }
            },
    );
  }

  Widget textoRecuperar(BuildContext context) {
    return GestureDetector(
        //Text.rich permite crear un texto compuesto, como un Row.
        child: Text.rich(
          TextSpan(
            text: "¿No recuerdas tú contraseña?",
            style: Theme.of(context).textTheme.headline1,
            children: <TextSpan>[
              TextSpan(
                  text: ", pulsa aquí.",
                  style: TextStyle(decoration: TextDecoration.underline)),
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, "recuperar");
        });
  }

  showSnackBar(BuildContext context, String text) {
    final snack = SnackBar(
      content: Text(text),
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }
}
