import 'package:capama_app/models/empleado_model.dart';
import 'package:capama_app/models/reporte_usuario_model.dart';
import 'package:capama_app/models/usuario_model.dart';
import 'package:flutter/material.dart';

class UsuarioProvider with ChangeNotifier 
{
  Usuario _usuarioActual;
  bool _login = false;
  ReporteUsuario _reportedatos;
  Empleado _empleado;

 get empleado => _empleado;
set empleado (Empleado data)
{
  this._empleado = data;
}
//Varible para el manejo de inicio de sesión
//Estado: no implementada
//Permite saber si el usuario inicio sesión en la app, también permite hacer logout
  get login => _login;
  set login(bool logout) {
    this._login = logout;
    notifyListeners();
  }

//Variable para el manejo de información referente a los datos del usuario
//Estado: Implementado, se maneja datos de la bd
//Permite manejar datos del usuario, para mostrar y generar los reportes
  get usuario => _usuarioActual;

  set usuario(Usuario data) {
    this._usuarioActual = data;
    notifyListeners();
  }

  //Variable para manejar información referente a los reportes
  get reportedatos => _reportedatos;

  set reportedatos(ReporteUsuario reportedata) {
    this._reportedatos = reportedata;
    notifyListeners();
  }

}
