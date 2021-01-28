import 'dart:convert';
import 'dart:io';
import 'package:capama_app/database/database_conn.dart';
import 'package:capama_app/models/reporte_usuario_model.dart';
import 'package:capama_app/services/bloc.dart';
import 'package:capama_app/src/user/welcome_page.dart';
import 'package:capama_app/utils/loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  int _currentStep = 0; //Me permite manejar los "estados" de Column
  PickedFile _imagen; //Permite cargar la imagen, pero solo ocupamos el path
  final _picker = ImagePicker();
  var imageUrl;
  bool isloading = false;
  bool imagensubida = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loadingModel = true;
  List _outputs;
  bool _nofuga = false;

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {
        _loadingModel = false;
      });
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return _loadingModel
        ? Loading()
        : Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Realizar reporte"),
              centerTitle: true,
            ),
            body: Center(
              child: ListView(
                padding:
                    EdgeInsets.symmetric(vertical: _screenSize.height * 0.2),
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: menu(context),
                    /*
            Para poder manejar "estados" dentro de la vista uso el currentStep para
            reconstruir los widgets, eso me evita perder la imagen ya cargada y solo
            muestro la siguiente parte del menú 
             */
                  )
                ],
              ),
            ),
          );
  }

/*
Con este metodo hago una validación del currentStep, con eso
puedo saber que debo mostrar en pantalla
si es 0, entonces muestro el picker.
si es 1, entonces muestro la imagen y la opción de volver a tomar
para la opcion 1, hago otro metodo y su validación correspondiente
 */
  List<Widget> menu(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    if (_currentStep == 0) //Devuelvo el picker
    {
      return [
        imageLogin(context),
        SizedBox(height: _screenSize.height * 0.05),
        boton(context, "Opciones para subir"),
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
        Center(
          child: Image.file(
            File(_imagen.path),
            height: _screenSize.height * 0.4,
          ),
        ),
        SizedBox(height: 20.0),
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
      if (image != null) {
        _imagen = image;
        classifyImage(File(_imagen.path));
        _currentStep = 1;
      }
    });
  }

  _imgFromGallery() async {
    final PickedFile image =
        await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _imagen = image;
        classifyImage(File(_imagen.path));
        _currentStep = 1;
      }
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

  Widget boton(BuildContext context, String texto) {
    final _screenSize = MediaQuery.of(context).size;
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _screenSize.width * 0.24,
            vertical: _screenSize.height * 0.032),
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

  Widget continuar(BuildContext context) {
    Conexion query = new Conexion();
    final _screenSize = MediaQuery.of(context).size;
    ReporteUsuario reportdata =
        Provider.of<UsuarioProvider>(context, listen: false).reportedatos;
    print(reportdata);
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
      onPressed: _nofuga
          ? null
          : () async {
              if (_outputs[0]["label"] != "2 no_fuga") {
                reportdata.setPrioridad =
                    _outputs[0]["label"] == "1 fuga_leve" ? "Leve" : "Grave";
                await uploadImage(_imagen);
                if (await query.insertReportUser(reportdata, imageUrl) ||
                    imagensubida) {
                  mensajeEnviado(context);
                } else {
                  showSnackBar(
                      context, "Ocurrió un error!, intente más tarde.");
                }
              } else {
                showSnackBar(context, "Esto no parece ser una fuga!");
              }
            },
    );
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
      'folder': 'reportes_usuario',
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
        //Remueve todo lo de la pila y manda a la siguiente pantalla
        //No sé porque no me deja usar el "login" asi que use el MaterialPageRoute
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => WelcomePage()),
            (Route<dynamic> route) => false);
      },
    );
  }

  /*
  Tanto las funciones de carga e inicializaciadores del ML deben ser los últimos
  dentro de los metodos.
   */
  loadModel() async {
    print("Preparando...");
    await Tflite.loadModel(
      model: "assets/ml/model_unquant.tflite",
      labels: "assets/ml/labels.txt",
    );
    print("Listo");
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      /*Opc */
      threshold: 0.5,
      /*Opc */
      imageMean: 127.5,
      /*Opc */
      imageStd: 127.5, /*Opc */
    );
    setState(() {
      _outputs = output;
      print(output[0]["label"].toString());
    });
  }
}
