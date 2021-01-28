import 'dart:convert';
import 'dart:io';

import 'package:capama_app/database/database_conn.dart';
import 'package:capama_app/models/reporte_usuario_model.dart';
import 'package:capama_app/services/bloc.dart';
import 'package:capama_app/src/employee/employee_welcome_page.dart';
import 'package:capama_app/utils/buscarCP.dart';
import 'package:capama_app/utils/buscarDireccion.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class AttendedReportPage extends StatefulWidget {
  @override
  _AttendedReportPageState createState() => _AttendedReportPageState();
}

class _AttendedReportPageState extends State<AttendedReportPage> {
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

  String _anomalia;

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

  int _idUser;

  int _currentStep = 0; //Me permite manejar los "estados" de Column
  PickedFile _imagen; //Permite cargar la imagen, pero solo ocupamos el path
  final _picker = ImagePicker();
  var imageUrl;
  bool isloading = false;
  bool imagensubida = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  ReporteUsuario data;
  List<Map> materialesTable = new List();
  String idReporte;

  @override
  void initState() {
    //porque lo uso:
    //https://stackoverflow.com/questions/56262655/flutter-get-passed-arguments-from-navigator-in-widgets-states-initstate
    Future.delayed(Duration.zero, () {
      setState(() {
         data = ModalRoute.of(context).settings.arguments;
        // print('s ${data.idUser}');
        _anomalia = data.anomalia;
        _servicioD = data.servicio;
        _idUser = data.idUser;
        _coloniaController.text = data.getColonia;
        _cpController.text = data.cp;
        idReporte = data.idReport;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   print(data);
    return Scaffold(
      appBar: AppBar(
        title: Text("Realizar reporte"),
      ),
      body: ListView(padding: EdgeInsets.all(20.0), children: [
        formulario(context),
      ]),
    );
  }

  Widget formulario(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _descripcion(context),
          _materiales(context),
          Center(
            child: Column(children: menu(context)),
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
            keyboardType: TextInputType.streetAddress,
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

  Widget _materiales(BuildContext context) {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Materiales usados:",
            style: Theme.of(context).textTheme.headline1,
          ),
          Row(
            children: [
              addMate(context,"Agregar material"),
              SizedBox(width: 5.0,),
              popMaterial(context,"Eliminar material")
            ],
          ),
          SizedBox(
            height: 10,
          ),
          DataTable(
            columns: [
              DataColumn(label: Text("Material")),
              DataColumn(label: Text("Cantidad")),

            ],
            rows:

             materialesTable.map(
                ((element) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(element["Materiales"])),
                        DataCell(Text(element["Cantidad"])),
                      ],
                    )),
              )
              .toList(),
          ),
        ],
      ),
    );
  }

  List<Widget> menu(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    if (_currentStep == 0) //Devuelvo el picker
    {
      return [
        imageLogin(context),
        SizedBox(height: _screenSize.height * 0.05),
        boton(context, "opciones para subir"),
      ];
    }
    if (_currentStep == 1) //Muestro imagen cargada o muestro "no imagen"
    {
      return [
        Column(
          children: menuopt2(context),
        ),
      ];
    }
    //Default por si no existe el current
  }

/* 
Lo mismo de arriba
*/
  menuopt2(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    /*
    Puede que el usuario abra el picker, pero no seleccione nada
    valido que realemente tenga algo
     */
    if (_imagen != null) {
      return [
        Container(
          margin: EdgeInsets.zero,
          child: Image.file(
            File(_imagen.path),
            width: _screenSize.width * 0.7,
            height: _screenSize.height * 0.7,
          ),
        ),
        continuar(context),
        SizedBox(height: 20.0),
        boton(context, "seleccionar otra foto")
      ];
    } else {
      return [
        Center(child: Text("No hay foto seleccionada")),
        SizedBox(height: 20.0),
        boton(context, "seleccionar foto"),
      ];
    }
  }

/*
Metodos para usar el ImagePicker.
Similares a la documentación.
 */
  _imgFromCamera() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _imagen = image;
      _currentStep = 1;
    });
  }

  _imgFromGallery() async {
    final PickedFile image =
        await _picker.getImage(source: ImageSource.gallery);
    print(image.path);
    setState(() {
      _imagen = image;
      _currentStep = 1;
    });
  }

//El menú que se muestra abajo para seleccionar
//Sacadito del curso de fernando ;)
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Seleccionar desde el teléfono'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                        setState(() {
                          _currentStep = 1;
                        });
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Hacer una foto'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                      setState(() {
                        _currentStep = 1;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget imageLogin(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
        child: Image(
      fit: BoxFit.contain,
      image: AssetImage("assets/img/pick.png"),
      width: _screenSize.width * 1,
      height: _screenSize.height * 0.3,
    ));
  }

  Widget boton(BuildContext context, String texto) 
  {
    final _screenSize = MediaQuery.of(context).size;
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _screenSize.width * 0.19,
            vertical: _screenSize.height * 0.024),
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
      onPressed: () {
        _showPicker(context);
      },
    );
  }

  Widget addMate(BuildContext context, String texto) 
  {
    final _screenSize = MediaQuery.of(context).size;
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _screenSize.width * 0.01,
            vertical: _screenSize.height * 0.024),
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
      onPressed: () async{
        final result = await Navigator.pushNamed(context, "materiales");
        if(result != null)
        {
          print("Lo agrego pes");
          print(result);
          setState(()=> materialesTable.add(result));

        }
        else
        {
          print("nmms ta' vacio");
        }
        
      },
    );
  }

   Widget popMaterial(BuildContext context, String texto) 
  {
    final _screenSize = MediaQuery.of(context).size;
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _screenSize.width * 0.01,
            vertical: _screenSize.height * 0.024),
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
      onPressed: () {
        if(materialesTable.isNotEmpty)
        {
          setState(()=>materialesTable.removeLast());
        }
      },
    );
  }

  Widget continuar(BuildContext context) {
    Conexion query = new Conexion();
    final _screenSize = MediaQuery.of(context).size;

    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _screenSize.width * 0.24,
            vertical: _screenSize.height * 0.024),
        child: Text(
          'Realizar reporte',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      color: Colors.blue,
      onPressed: isloading
          ? null
          : () async {
           
          
              if (_formKey.currentState.validate()) {
                
                await uploadImage(_imagen);
                if (await query.attendedReport( data, imageUrl, _descripcionController.text) || imagensubida) 
                  {
                  String id = await query.queryIdReportEmpleado(idReporte);
                  String materialdata = mapToQuery(id); 
                  materialesTable.isEmpty?
                   print("Sin materiales")
                   :await query.executeMateriales(materialdata);
                  print("Materiales atachados...");
                  await query.updateReport("Atendido",idReporte);
                  await query.executeEstadoEmpleado(data.idempleado,"Disponible");
                  print("estado del empleado a Disponible");
                  print("Reporte atendido!");
                  print(' id ${data.idUser}');
                  await query.notifyUser(
                      _idUser,
                      'Atendido',
                      'Reporte finalizado',
                      'Su reporte ha sido antendido. ¡Gracias por ayudar a cuidar el agua!. Estado del reporte:');
                  mensajeEnviado(context);
                } else {
                  showSnackBar(
                      context, "Ocurrió un error!, intente más tarde.");
                }
              }
            },
    );
  }
//Para enviar los materiales en un solo query
String mapToQuery(String idReporte)
{
  String query ="";

  if(materialesTable.isNotEmpty)
  {
    materialesTable.map((v) {
      query = query + "('${v["Materiales"]}','${v["Cantidad"]}','$idReporte'),";
    }).toList();

  query = query.substring(0,query.length-1);
  print(query);
  return query;
  }
  return "";
}

  Future uploadImage(PickedFile imagen) async {
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);

    const url = "https://api.cloudinary.com/v1_1/dysntklpm/image/upload";
    pr.show();
    setState(() {
      isloading = false;
    });

    Dio dio = Dio();
    FormData formData = new FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imagen.path,
      ),
      'upload_preset': 'capama',
      'cloud_name': 'dysntklpm',
      'folder': 'reportes_empleado',
    });
    try {
      Response response = await dio.post(url, data: formData);

      var data = jsonDecode(response.toString());
      print(data['secure_url']);
      pr.hide();

      setState(() {
        isloading = true;
        imageUrl = data['secure_url'];
        imagensubida = true;
      });
    } catch (e) {
      print(e);
    }
  }

  showSnackBar(BuildContext context, String text) {
    final snack = SnackBar(
      content: Text(text),
    );
    _scaffoldKey.currentState.showSnackBar(snack);
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
            title: Text("Reporte generado"),
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

  //Este boton es del AlertDialog
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
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => EmployeeWelcome()),
            (Route<dynamic> route) => false);
      },
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
                onChanged: (opc) {
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
}
