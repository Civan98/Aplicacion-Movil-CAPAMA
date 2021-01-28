import 'dart:async';

import 'package:capama_app/database/database_conn.dart';

class ReportsBloc {
  var id;
  ReportsBloc(var id) {
    this.id = id;
    this.getReports.listen(
        (reportesList) => this._reportesLongitud.add(reportesList.length));
    this.getReportsEmploy.listen((reportesList) =>
        this._reportesLongitudEmploy.add(reportesList.length));
  }
  Conexion consultReports = new Conexion();
//directito del video de streams de fernando en youtube
  Stream<List<dynamic>> get getReports async* {
    List<dynamic> tempReports = await consultReports.queryRerportsUsers(id);

    final List<dynamic> reportsUser = [];
    //esperar los resultados. si se le pone menos de 2, el streambuilder no carga los datos
    await Future.delayed(Duration(seconds: 3));
    for (var reporte in tempReports) {
      // print('prueba');
      reportsUser.add(reporte);
      //retornar valores sin salir de la función.
      yield reportsUser;
    }
  }

//stream para cargar los datos del reporte asignado al empleado
  Stream<List<dynamic>> get getReportsEmploy async* {
    List<dynamic> tempReports = await consultReports.queryRerportsEmploy(id);

    final List<dynamic> reportsUser = [];
    //esperar los resultados. si se le pone menos de 2, el streambuilder no carga los datos
    await Future.delayed(Duration(seconds: 3));
    for (var reporte in tempReports) {
      // print('prueba');
      reportsUser.add(reporte);
      //retornar valores sin salir de la función.
      reporteEmploySink(reporte);

      yield reportsUser;
    }
  }

//stream para cargar los datos de los reportes atendidos del empleado, con los datos el reporte del usuario
  Stream<List<dynamic>> get getReportsAttended async* {
    List<dynamic> tempReports =
        await consultReports.queryRerportsEmployAttended(id);

    final List<dynamic> reportsUser = [];
    //esperar los resultados. si se le pone menos de 2, el streambuilder no carga los datos
    await Future.delayed(Duration(seconds: 2));
    for (var reporte in tempReports) {
      // print('prueba');
      reportsUser.add(reporte);
      //retornar valores sin salir de la función.
      yield reportsUser;
    }
  }

//no se utiliza, pero es un contador, porsi aumenta en el futuro el tamaño de los reportes.
  StreamController<int> _reportesLongitud = new StreamController();
  Stream<int> get reportesContador => _reportesLongitud.stream;
  StreamController<int> _reportesLongitudEmploy = new StreamController();
  Stream<int> get reportesContadorEmploy => _reportesLongitudEmploy.stream;
//cerrar los streams
  dispose() {
    _reportesLongitud.close();
    _reportesLongitudEmploy.close();
    _reportEmployController.close();
  }

//////////////nueva implementación para los reportes de los empleados

  StreamController<List<dynamic>> _reportEmployController =
      StreamController<List<dynamic>>.broadcast();

  Function(List<dynamic>) get reporteEmploySink =>
      _reportEmployController.sink.add;
  Stream<List<dynamic>> get reportEmployStream =>
      _reportEmployController.stream;
}
