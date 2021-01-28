import 'package:capama_app/database/database_conn.dart';
import 'package:capama_app/models/usuario_model.dart';
import 'package:capama_app/utils/buscarCP.dart';
import 'package:capama_app/utils/buscarDireccion.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  TextEditingController _cpController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _coloniaController = TextEditingController();
  TextEditingController _calleController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contraController = TextEditingController();
  TextEditingController _contraController2 = TextEditingController();
  TextEditingController _contratoController = TextEditingController();
  bool _disablebutton = false;
  bool _pass2 = true;
  bool _pass1 = true;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _cpActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Crear nueva cuenta"),
        centerTitle: true,
      ),
      body: formulario(context),
    );
  }

  Widget formulario(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),
      children: [
       form(context),
      ],
    );
  }
Widget form(BuildContext context)
{
  return Form(
    key: _formKey,
    child: Column(
      children: [
         _contrato(context),
        _nombre(context),
        _apellidos(context),
        _colonia(context),
        _buscarCP(context),
        _calle(context),
        _numeroTelefono(context),
        _email(context),
        _contra(context),
        _contra2(context),
        _boton(context),
      ],
    ),
  );
}
  Widget _contrato(BuildContext context) {
    RegExp contrato = RegExp(r"[0-9]{3,3}\-[0-9]{3,3}\-[0-9]{4,4}\-[0-9]");
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Número de contrato:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _contratoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Num. de contrato:",
              suffixIcon: Icon(Icons.article_outlined),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
          validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            if(!contrato.hasMatch(_contratoController.text))
            {
              return "Contrato no válido,recuerde ingresar los guiones";
            }
            return null;
          },
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _nombre(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Nombre:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Nombre:",
              suffixIcon: Icon(Icons.person_outline),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _apellidos(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Apellidos:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _lastnameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Apellidos:",
              suffixIcon: Icon(Icons.person_outline),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
          validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _colonia(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Buscar ubicación:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _coloniaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Buscar ubicación:",
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    final result = await showSearch(
                      context: context,
                      delegate: AddressSearch(),
                    );

                    if (result != null) {
                      setState(() {
                        _coloniaController.text = result;
                        _cpActive = false;
                        print(result);
                      });
                    }
                  }),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _buscarCP(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Buscar CP:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _cpController,
            readOnly: _cpActive,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "ej.39748",
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _cpActive
                      ? null
                      : () async {
                          final result = await showSearch(
                            context: context,
                            delegate: CPSearch(colonia: _coloniaController.text),
                          );

                          if (result != null) {
                            setState(() {
                              _cpController.text = result;
                              print(result);
                            });
                          }
                        }),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _calle(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Calle:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _calleController,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Calle:",
              suffixIcon: Icon(Icons.location_city),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _numeroTelefono(BuildContext context) {
  RegExp telefono = RegExp(r"^(\(\+?\d{2,3}\)[\*|\s|\-|\.]?(([\d][\*|\s|\-|\.]?){6})(([\d][\s|\-|\.]?){2})?|(\+?[\d][\s|\-|\.]?){8}(([\d][\s|\-|\.]?){2}(([\d][\s|\-|\.]?){2})?)?)$");
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Número de teléfono:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _telefonoController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Número de teléfono:",
              suffixIcon: Icon(Icons.phone_outlined),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }

            if(!telefono.hasMatch(_telefonoController.text))
            {
              return "Ingrese un número telefónico válido.";
            }
            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _email(BuildContext context) {
RegExp expCorreo = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Correo electrónico:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Correo electrónico:",
              suffixIcon: Icon(Icons.email_outlined),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            if(!expCorreo.hasMatch(_emailController.text))
            {
              return "Ingrese un correo válido.";
            }
            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _contra(BuildContext context) {
    return Container(
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
            controller: _contraController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _pass1?true:false,
            decoration: InputDecoration(
              suffixIcon: IconButton(icon: Icon(_pass1?Icons.remove_red_eye_outlined:Icons.lock),
               onPressed:(){
                 setState(() => _pass1 = !_pass1);
               } ),
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Contraseña:",
              // suffixIcon: Icon(Icons.remove_red_eye_outlined),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            if(value != _contraController2.text)
            {
              return "Las contraseñas no conciden";
            }
            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _contra2(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Repetir contraseña:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _contraController2,
            keyboardType: TextInputType.visiblePassword,
            obscureText: _pass2?true:false,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "Repetir contraseña:",
             suffixIcon: IconButton(icon: Icon(_pass2?Icons.remove_red_eye_outlined:Icons.lock),
               onPressed:(){
                 setState(() => _pass2 = !_pass2);
               } ),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            
            if(value != _contraController.text)
            {
              return "Las contraseñas no conciden";
            }

            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  Widget _boton(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    Usuario registro = new Usuario();
    Conexion exec =  new Conexion();
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    return Column(
      children: [
        SizedBox(height: 10.0),
        RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:_screenSize.height*0.13 , vertical: 24.0),
            child: Text(
              'Realizar registro',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 0.0,
          color: Colors.blue,

          onPressed: _disablebutton? null : () async {
            if(_formKey.currentState.validate())
            {
              setState(() => _disablebutton = true);
              registro.setNombre = _nameController.text;
              registro.setApellidos =_lastnameController.text;
              registro.setColonia = _coloniaController.text;
              registro.setCp = _cpController.text;
              registro.setCalle = _calleController.text;
              registro.setTelefono =_telefonoController.text;
              registro.setCorreos = _emailController.text;
              registro.setContrasena = _contraController.text;
              registro.setContrato = _contratoController.text;
              if(!await exec.queryEmailUser(_emailController.text))
              {
                if(!await exec.queryContrato(_contratoController.text))
                {
                  if(await exec.insertUser(registro))
                  {
                    Navigator.popAndPushNamed(context, "login");
                  }

                  else
                  {
                    showSnackBar(context,"Ocurrío un error!");
                   setState(() => _disablebutton = false);
                  }
                }
                else
                {
                  showSnackBar(context,"Parece que el contrato ya esta registrado.");
                   setState(() => _disablebutton = false);
                }
              }
              else
              {
                showSnackBar(context,"el correo ya está registrado!");
                 setState(() => _disablebutton = false);
              }
            }
            //showSnackBar(context,"Ocurrió un error! intenté más tarde");
            //Navigator.pushNamed(context, "login");
          },
        ),
        SizedBox(height: 50.0),
      ],
    );
  }

 showSnackBar(BuildContext context, String text) {
    final snack = SnackBar(
      content: Text(text),
    );
    _scaffoldKey.currentState.showSnackBar(snack);
  }

}
