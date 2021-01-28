import 'dart:math';
import 'package:capama_app/models/reporte_usuario_model.dart';
import 'package:capama_app/models/usuario_model.dart';
import 'package:capama_app/services/bloc.dart';
import 'package:capama_app/utils/buscarCP.dart';
import 'package:capama_app/utils/buscarDireccion.dart';
import 'package:capama_app/utils/loading.dart';
import 'package:capama_app/utils/zonas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DetailReport extends StatefulWidget {
  @override
  _DetailReportState createState() => _DetailReportState();
}

class _DetailReportState extends State<DetailReport> {
  List<String> _type = [
    'Falta de agua',
    'Falta de presión',
    'Fuga en la red Hidraulica',
    'Fuga en la toma',
    'Inspeccion',
    'Material listo',
    'Toma obstruida',
    'Toma desconectada',
    'Desazolve'
  ];
  List<String> _servicio = ['Agua potable', 'Pipas', 'Alcantarillado'];
  String _servicioD = "Alcantarillado";
  String _anomalia = "Fuga en la toma";
  String servicioD = "Agua potable";
  bool disablepipa = false;
  bool _cpActive = true;
  TextEditingController _cpController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _coloniaController = TextEditingController();
  TextEditingController _calleController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  String descripcion;
  String _idUser;
  final _formKey = GlobalKey<FormState>();
  bool _enableButton = false;
  bool _loading = false;
  @override
  void initState() {
    final usuarioData = Provider.of<UsuarioProvider>(context, listen: false);
    super.initState();
    _cpController = TextEditingController(text: usuarioData.usuario.cp);
    _nameController =
        TextEditingController(text: "${usuarioData.usuario.nombre}");
    _lastnameController =
        TextEditingController(text: "${usuarioData.usuario.apellidos}");
    _coloniaController =
        TextEditingController(text: "${usuarioData.usuario.colonia}");
    _calleController = TextEditingController(text: usuarioData.usuario.calle);
    _idUser = usuarioData.usuario.id;
  }

  @override
  void dispose() {
    // _cpController.dispose();
    // _nameController.dispose();
    // _coloniaController.dispose();
    // _descripcionController.dispose();
    // _cpController.dispose();
    // _lastnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Detalles del reporte"),
            ),
            body: ListView(
              padding: EdgeInsets.all(10.0),
              children: <Widget>[
                formulario(context),
              ],
            ),
          );
  }

  Widget formulario(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _tipoReportes(),
          SizedBox(height: _screenSize.height * 0.02),
          _tipoServicio(),
          SizedBox(height: _screenSize.height * 0.02),
          _nombre(context),
          SizedBox(height: _screenSize.height * 0.02),
          _apellidos(context),
          SizedBox(height: _screenSize.height * 0.02),
          _colonia(context),
          SizedBox(height: _screenSize.height * 0.02),
          _buscarCP(context),
          SizedBox(height: _screenSize.height * 0.02),
          _calle(context),
          SizedBox(height: _screenSize.height * 0.02),
          _descripcion(context),
          SizedBox(height: _screenSize.height * 0.02),
          //Según el viejo wango de aldo debe de enviarse ciertos datos
          //Por el momento se envia todo, los objetos ya estan.
          boton(context, disablepipa ? "Solicitar pipa" : "Continuar"),
          SizedBox(height: _screenSize.height * 0.02),
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
              hintText: "ej. Aldo Valdez Solis",
              suffixIcon: Icon(Icons.person_outline),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "¡Este campo es obligatorio!";
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
              hintText: "ej. Aldo Valdez Solis",
              suffixIcon: Icon(Icons.person_outline),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "¡Este campo es obligatorio!";
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
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "ej. Jijilpan",
              suffixIcon: Icon(Icons.location_city),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "¡Este campo es obligatorio!";
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

  Widget _descripcion(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Descripción:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _descripcionController,
            maxLines: 10,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "ej. tubo oxidado,aguas negras",
              // suffixIcon: Icon(Icons.remove_red_eye_outlined),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return "¡Este campo es obligatorio!";
              }
              return null;
            },
            onChanged: (value) {
              descripcion = value.toString();
            },
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
            "Buscar ubicación (Colonia):",
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
                            delegate:
                                CPSearch(colonia: _coloniaController.text),
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
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpsDropDown() {
    List<DropdownMenuItem<String>> lista = new List();
    _type.forEach((dato) {
      lista.add(DropdownMenuItem(
        child: Text(dato),
        value: dato,
      ));
    });
    return lista;
  }

  Widget _tipoReportes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tipo anomalia:",
          style: Theme.of(context).textTheme.headline1,
        ),
        Row(
          children: [
            Icon(Icons.select_all),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: DropdownButton(
                value: _anomalia,
                items: getOpsDropDown(),
                onChanged: disablepipa
                    ? null
                    : (opc) {
                        setState(() {
                          _anomalia = opc;
                        });
                      },
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> getReport() {
    List<DropdownMenuItem<String>> lista = new List();
    _servicio.forEach((dato) {
      lista.add(DropdownMenuItem(
        child: Text(dato),
        value: dato,
      ));
    });
    return lista;
  }

  Widget _tipoServicio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tipo de servicio:",
          style: Theme.of(context).textTheme.headline1,
        ),
        Row(
          children: [
            Icon(Icons.select_all),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: DropdownButton(
                value: _servicioD,
                items: getReport(),
                onChanged: (opc) {
                  setState(() {
                    if (opc == "Pipas") {
                      disablepipa = true;
                    } else {
                      disablepipa = false;
                    }
                    _servicioD = opc;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  String generarFolio(String nombre, var time) {
    Random random = new Random();
    int randomNumber = random.nextInt(100);
    String iniciales = "";
    var valores = nombre.split(' ');

    valores.forEach((values) {
      iniciales = iniciales + values[0];
    });
    iniciales +=
        "${time.year}${time.month}${time.day}${time.hour}${time.hour}${time.minute}${time.second}";
    iniciales += randomNumber.toString();
    return iniciales;
  }

  Widget boton(BuildContext context, String texto) {
    Zona zonaSearch = new Zona();
    zonaSearch.setZona = (_coloniaController.text);
    final _screenSize = MediaQuery.of(context).size;
    final reportedata = Provider.of<UsuarioProvider>(context, listen: false);
    ReporteUsuario reporte = new ReporteUsuario();
    var time = DateTime.now();
    print("Hora de flutter: $time");
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _screenSize.width * 0.32, vertical: 25.0),
        child: Text(
          texto,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      color: Colors.blue,
      onPressed: _enableButton
          ? null
          : () async {
              setState(() => _enableButton = true);
              var location = new Location();
              var act = await location.getLocation();
              if (_formKey.currentState.validate()) {
                setState(() {
                  _loading = true;
                });

                reporte.setNombre = _nameController.text;
                reporte.setApellidos = _lastnameController.text;
                reporte.setColonia = _coloniaController.text;
                reporte.setCp = _cpController.text;
                reporte.setCalle = _calleController.text;
                reporte.setDescripcion = _descripcionController.text;
                reporte.setZona = zonaSearch.getZona.toString();
                reporte.setAnomalia = _anomalia;
                reporte.setServicio = _servicioD;
                reporte.setFolio = generarFolio(
                    "${_nameController.text} ${_lastnameController.text}",
                    time.toUtc());
                reporte.setIdUser = int.parse(_idUser);
                reporte.setNumeroInt = "220";
                reporte.setNumeroExt = "41";
                reporte.setLatitud = act.latitude.toString();
                reporte.setLongitud = act.longitude.toString();
                reporte.setFoto = "no photo"; /*Se asigna en la siguiente*/
                reporte.setEstado = "Nuevo";
                reporte.setFecha = time.toUtc();
                reporte.setPrioridad = "Leve";
                reportedata.reportedatos = reporte;

                setState(() {
                  _enableButton = false;
                  _loading = false;
                });
                Navigator.pushNamed(context, "reportes");
              } else {
                setState(() => _enableButton = false);
              }
            },
    );
  }
}
