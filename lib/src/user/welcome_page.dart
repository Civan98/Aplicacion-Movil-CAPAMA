import 'package:capama_app/database/database_conn.dart';
import 'package:capama_app/models/usuario_model.dart';
import 'package:capama_app/services/bloc.dart';
import 'package:capama_app/services/reports_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Conexion consultReports = new Conexion();
    final _screenSize = MediaQuery.of(context).size;
    final usuarioData = Provider.of<UsuarioProvider>(context);
    final user = usuarioData.usuario;
    ReportsBloc reporteBloc = new ReportsBloc(user.id);
    return Scaffold(
        drawer: Drawer(
          child: _drawerData(context, user),
        ),
        appBar: AppBar(
          elevation: 0.0,
          title: Text("Menú principal"),
          centerTitle: true,
          actions: [
            CustomPaint(
                painter: _CirculoAlerta(haymensaje: true),
                child: notificacionIcon())
          ],
        ),
        backgroundColor: Colors.blue,
        body: Container(
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
                      Center(
                        child: Text(
                          'Información de la cuenta',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text('Nombre: ${user.nombre}  ${user.apellidos}'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('Contrato: ${user.contrato}'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('Email: ${user.correos}'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('Telefono: ${user.telefono}'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('Dirección: ${user.colonia}, '
                          'calle ${user.calle}'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('C.P. ${user.cp}'),
                      SizedBox(
                        height: 12.0,
                      ),
                      FadeInImage(
                      image: NetworkImage('https://res.cloudinary.com/dysntklpm/image/upload/v1609312924/agua_tmybey.jpg'),
                      placeholder: AssetImage('assets/img/loading.gif'),
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                        height: 12.0,
                      ),
                    ])))));
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
      onTap: () {
        Navigator.pushNamed(context, "seguimiento");
      },
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
