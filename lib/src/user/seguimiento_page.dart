import 'package:capama_app/database/database_conn.dart';
import 'package:capama_app/models/usuario_model.dart';
import 'package:capama_app/services/bloc.dart';
import 'package:capama_app/services/reports_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Seguimiento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Conexion consultReports = new Conexion();
    final _screenSize = MediaQuery.of(context).size;
    final usuarioData = Provider.of<UsuarioProvider>(context);
    final user = usuarioData.usuario;
    ReportsBloc reporteBloc = new ReportsBloc(user.id);
    return Scaffold(
      // drawer: Drawer(
      //   child: _drawerData(context, user),
      // ),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Seguimiento reportes"),
        centerTitle: true,
        actions: [
          CustomPaint(
              painter: _CirculoAlerta(haymensaje: true),
              child: notificacionIcon())
        ],
      ),
      backgroundColor: Colors.blue,
      body: StreamBuilder(
        stream: reporteBloc.getReports,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            // print(snapshot.connectionState);
            return Center(
                child:
                    CircularProgressIndicator(backgroundColor: Colors.white));
          }
          final report = snapshot.data;
          // print(report[1]);
          return ListView.builder(
            itemCount: report.length,
            itemBuilder: (context, i) {
              return Container(
                margin: EdgeInsets.symmetric(
                    horizontal: _screenSize.width * 0.04,
                    vertical: _screenSize.height * 0.001),
                child: Card(
                  child: ListTile(
                    title: Text(
                      report[i][4].toString(),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                        '${report[i][8]} \nCalle: ${report[i][9]} \nEstado: ${report[i][15]}'),
                    leading: Container(
                        height: double.infinity,
                        child: Text(report[i][6].toString())),
                    trailing: Container(
                        height: double.infinity,
                        child: Icon(Icons.arrow_forward_outlined)),
                    onTap: () {
                      Navigator.of(context).pushNamed("detalleReporteUsuario",
                          arguments: report[i]);
                    },
                  ),
                ),
              );
            },
          );
        },
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

  Widget _drawerData(BuildContext context, Usuario datoUsuario) {
    return ListView(
      children: <Widget>[
        headerInfo(datoUsuario),
        logout(context),
        realizarReporte(context),
        seguimientoReporte(context),
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

  Widget realizarReporte(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.warning),
      title: Text(
        "Realizar reporte",
        style: Theme.of(context).textTheme.headline1,
      ),
      onTap: () {
        Navigator.of(context).pushNamed("detalleReporte");
      },
    );
  }

  Widget seguimientoReporte(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.search),
      title: Text(
        "Seguimiento de mis reportes",
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
        Navigator.of(context).pushNamed("datosUser");
      },
    );
  }

//La información que se muestra en la cabecera del Drawer
  Widget headerInfo(Usuario datoUsuario) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: Container(
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            userPhoto(),
            userName(datoUsuario),
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

  Widget userName(datoUsuario) {
    return Center(
      child: Text(
        "${datoUsuario.nombre} ${datoUsuario.apellidos}",
        style: TextStyle(
          color: Colors.white,
          fontFamily: "MPLUSRounded1c",
          fontSize: 18.0,
        ),
      ),
    );
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
