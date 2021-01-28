import 'package:capama_app/database/database_conn.dart';
import 'package:capama_app/models/usuario_model.dart';
import 'package:capama_app/services/bloc.dart';
import 'package:capama_app/services/reports_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsAttendedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Conexion materiales = new Conexion();
    final _screenSize = MediaQuery.of(context).size;
    final employData = Provider.of<UsuarioProvider>(context).empleado;
    ReportsBloc reporteBloc = new ReportsBloc(employData.id);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Reportes atendidos"),
        centerTitle: true,
        // actions: [
        //   CustomPaint(
        //       // painter: _CirculoAlerta(haymensaje: true),
        //       child: notificacionIcon())
        // ],
      ),
      backgroundColor: Colors.blue,
      body: StreamBuilder(
        stream: reporteBloc.getReportsAttended,
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            // print(snapshot.connectionState);
            return Center(
                child: Text(
              'No hay reportes atendidos.',
              style: TextStyle(color: Colors.white),
            ));
          }

          final report = snapshot.data;
          // print(report.length);
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
                    onTap: () async {
                      List<dynamic> materialesUsados = [];
                      materialesUsados =
                          materiales.queryMaterials(report[i][18]);
                      await Future.delayed(Duration(seconds: 1));
                      print('maU $materialesUsados');

                      Navigator.of(context).pushNamed("detalleReporteEmpleado",
                          arguments: [report[i], materialesUsados]);
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
}
