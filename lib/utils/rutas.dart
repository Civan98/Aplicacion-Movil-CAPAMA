import 'package:capama_app/src/employee/employee_welcome_page.dart';
import 'package:capama_app/src/employee/modInfoEmployee_page.dart';
import 'package:capama_app/src/employee/reports/attended_reportUser.dart';
import 'package:capama_app/src/employee/reports/detail_report_employed.dart';
import 'package:capama_app/src/employee/reports/reports_attended.dart';
import 'package:capama_app/src/user/reports/detalle_reporte_page.dart';
import 'package:capama_app/src/user/reports/maps.dart';
import 'package:capama_app/src/user/seguimiento_page.dart';
import 'package:flutter/material.dart';
import 'package:capama_app/src/login/principal_page.dart';
import 'package:capama_app/src/login/login_page.dart';
import 'package:capama_app/src/login/register_page.dart';
import 'package:capama_app/src/login/reset_page.dart';
import 'package:capama_app/src/user/welcome_page.dart';
import 'package:capama_app/src/user/modInfoUser_page.dart';
import 'package:capama_app/src/user/reports/makeReport.dart';
import 'package:capama_app/src/user/reports/detail_report_page.dart';
import 'package:capama_app/src/employee/reports/material_page.dart';

rutas() {
  return <String, WidgetBuilder>{
    "/"                     : (BuildContext context) => PrincipalPage(),
    "login"                 : (BuildContext context) => LoginPage(),
    "registro"              : (BuildContext context) => RegisterPage(),
    "recuperar"             : (BuildContext context) => ResetPage(),
    "welcome"               : (BuildContext context) => WelcomePage(),
    "datosUser"             : (BuildContext context) => ModInfoPage(),
    "reportes"              : (BuildContext context) => ReportPage(),
    "detalleReporte"        : (BuildContext context) => DetailReport(),
    "detalleReporteUsuario" : (BuildContext context) =>DetallesPage(), //estos son los detalles del repote del usuario, el otro es para hacer el reporte
    "mapa"                  : (BuildContext context) => FullScreenMap(),
    "empleado_home"         : (BuildContext context) => EmployeeWelcome(),
    "reports_attended"      : (BuildContext context) => ReportsAttendedPage(),
    "detalleReporteEmpleado": (BuildContext context) => DetallesEmployedPage(),
    "seguimiento"           : (BuildContext context) => Seguimiento(),
    "reporteEmpleado"       : (BuildContext context) => AttendedReportPage(),
    "editarEmpleado"        : (BuildContext context) => ModEmployee(),
    "materiales"            : (BuildContext context) => MaterialesPage(),
  };
}
