import 'package:capama_app/database/database_conn.dart';
import 'package:capama_app/models/empleado_model.dart';
import 'package:capama_app/models/reporte_usuario_model.dart';
import 'package:capama_app/models/usuario_model.dart';
import 'package:capama_app/services/bloc.dart';
import 'package:capama_app/services/reports_user_bloc.dart';
import 'package:capama_app/utils/enviarEmail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeWelcome extends StatefulWidget {
  @override
  _EmployeeWelcomeState createState() => _EmployeeWelcomeState();
}

class _EmployeeWelcomeState extends State<EmployeeWelcome> {
  bool _disableButton = false;
  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final employData = Provider.of<UsuarioProvider>(context).empleado;
    ReportsBloc reporteBloc = new ReportsBloc(employData.id);
    var stream = reporteBloc.reportEmployStream;
    int idrep = -1;
    return Scaffold(
      drawer: Drawer(
        child: _drawerData(context, employData),
      ),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Reporte Asignado"),
        centerTitle: true,
        // actions: [
        //   CustomPaint(
        //       // painter: _CirculoAlerta(haymensaje: true),
        //       child: notificacionIcon())
        // ],
      ),
      backgroundColor: Colors.blue,
      body: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Text(
              'No hay reporte asignado.',
              style: TextStyle(color: Colors.white),
            ));
          }
          final report = snapshot.data;
// si no hay un reporte, mostrar leyenda de que no hay reportes.
          if (report.isEmpty) {
            return Center(
                child: Text(
              'No hay reporte asignado.',
              style: TextStyle(color: Colors.white),
            ));
          }
          ReporteUsuario reporte = ReporteUsuario.fromEmployee(report);
          idrep = report[0];
          DateTime fecha = report[14];
          fecha = fecha.toLocal();
          return Container(
            margin: EdgeInsets.symmetric(horizontal: _screenSize.width * 0.05),
            width: _screenSize.width * 0.95,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Container(
              margin:
                  EdgeInsets.symmetric(horizontal: _screenSize.width * 0.05),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Folio de seguimiento: ${report[4]}'),
                    Text('Tipo de servicio: ${report[3]}'),
                    Text('Tipo de anomalía: ${report[2]}'),
                    Text('Zona: ${report[1]}'),
                    Text('Colonia: ${report[8]}'),
                    Text('Calle: ${report[9]}'),
                    Text('Código Postal: ${report[10]}'),
                    Text(
                        'Número interior: ${report[11]}   Número exterior: ${report[12]}'),
                    Text('Descripción: ${report[13]}'),
                    Text(
                        'Fecha del reporte: ${fecha.year}/${fecha.month}/${fecha.day}'),
                    Text('Estado del reporte: ${report[15]}'),
                    Text('Foto del reporte:'),
                    FadeInImage(
                      image: NetworkImage(report[5].toString()),
                      placeholder: AssetImage('assets/img/loading.gif'),
                      fit: BoxFit.cover,
                    ),
                    Container(
                        //se manda a llamar la clase que crea el mapa
                        child: Center(
                      child: Card(
                          color: Colors.blue[200],
                          child: FlatButton(
                              //
                              onPressed: () {
                                Navigator.pushNamed(context, "mapa",
                                    arguments: report[7]);
                              },
                              child: Text("Ver en el mapa"))),
                    )),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          makeReport(context, report[15], reporte),
                          SizedBox(
                            height: 20.0,
                          ),
                          acept(context, report[15], report[0].toString(),
                              report[17]),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          final Conexion query = new Conexion();
          print('refresh');
          print(idrep);
          setState(() {
            print('refresh2');
            stream = reporteBloc.reporteEmploySink([]);
            stream = reporteBloc.reportEmployStream;
          });

          if (idrep != -1) {
            //buscar actualiciones
            //si el reporte actual no es nuevo o atendido, refrescar el stream
            if (await query.reportUserChange(idrep)) {
              setState(() {
                print('refresh2');
                stream = reporteBloc.reportEmployStream;
              });
            } else {
              //si el reporte actual es ahora atendido o Nuevo, añadir [] al stream

              setState(() {
                stream = reporteBloc.reporteEmploySink([]);
              });
            }
          }
        },
        child: Icon(
          Icons.refresh_outlined,
          color: Colors.blue,
        ),
      ),
    );
  }

  IconButton notificacionIcon() {
    return IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () {
          print("Enviar a seguimiento de reportes");
        });
  }

  Widget _drawerData(BuildContext context, Empleado datoEmpleado) {
    return ListView(
      children: <Widget>[
        headerInfo(datoEmpleado),
        logout(context),
        reportesAtendidos(context),
        // realizarReporte(context),
        // seguimientoReporte(context),
        modificarDatos(context),
      ],
    );
  }

  Widget logout(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout),
      title: Text(
        "Cerrar sesión",
        style: Theme.of(context).textTheme.headline1,
      ),
      onTap: () {},
    );
  }

  Widget modificarDatos(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.create_rounded),
      title: Text(
        "Modificar datos personales",
        style: Theme.of(context).textTheme.headline1,
      ),
      onTap: () {
         Navigator.of(context).pushNamed("editarEmpleado");
      },
    );
  }

  Widget headerInfo(Empleado datoEmpleado) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Container(
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            userPhoto(),
            userName(datoEmpleado),
          ],
        ),
      ),
    );
  }

  Widget userPhoto() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: CircleAvatar(
        radius: 50.0,
        child: CircleAvatar(
          radius: 50.0,
          backgroundImage: AssetImage("assets/img/user_logo.png"),
        ),
      ),
    );
  }

  Widget userName(datoEmpleado) {
    return Center(
      child: Text(
        "${datoEmpleado.nombre} ${datoEmpleado.apellidos}",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "MPLUSRounded1c",
          fontSize: 18.0,
        ),
      ),
    );
  }

  reportesAtendidos(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.list_alt_outlined),
      title: Text(
        "Reportes atendidos",
        style: Theme.of(context).textTheme.headline1,
      ),
      onTap: () {
        Navigator.of(context).pushNamed("reports_attended");
      },
    );
  }

  Widget makeReport(
      BuildContext context, String estado, ReporteUsuario report) {
    final _screenSize = MediaQuery.of(context).size;

    return (estado != "Monitoreado")
        ? Container()
        : Container(
            height: _screenSize.height * 0.1,
            width: _screenSize.width * 0.5,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(8.0)),
            child: FlatButton(
                onPressed: () {
                  Navigator.pushNamed(context, "reporteEmpleado",
                      arguments: report);
                },
                child: Text(
                  'Crear reporte',
                  style: TextStyle(color: Colors.white),
                )));
  }

  Widget acept(
      BuildContext context, String estado, String idReporte, int idUser) {
    final _screenSize = MediaQuery.of(context).size;
    final Conexion queryo = new Conexion();
    return (estado != "En proceso")
        ? Container()
        : Container(
            height: _screenSize.height * 0.1,
            width: _screenSize.width * 0.5,
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(8.0)),
            child: RaisedButton(
              color: Colors.blue,
                onPressed: _disableButton?null: () async {
                  setState(()=>_disableButton = true);
                  if (await queryo.updateReport("Monitoreado", idReporte)) {
                    queryo.notifyUser(
                        idUser,
                        'Monitoreado',
                        'Su reporte ha sido actualizado',
                        'Su reporte ha cambiado de estado:');
                    print("Ok");
                  } else {
                    print("Error");
                  }
                },
                child: Text(
                  'Aceptar reporte',
                  style: TextStyle(color: Colors.white),
                )));
  }
}

//Crea el circulo rojo cuando exista un mensaje
//Se envia un bool si existe al menos 1 para dibujarlo
//Supongo que también el número de mensajes
class _CirculoAlerta extends CustomPainter {
  bool haymensaje;
  _CirculoAlerta({@required this.haymensaje});
  @override
  void paint(Canvas canvas, Size size) {
//Si existe mensajes que leer, se mostrará el icono
    if (haymensaje) {
      final paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill
        ..strokeWidth = 15;
      final path = Path();
      path.lineTo(0, size.height * 0.30);
      Offset center = Offset(size.width * 0.7, size.height * 0.2);
      canvas.drawCircle(center, 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
