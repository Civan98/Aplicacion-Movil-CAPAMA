import 'package:capama_app/models/empleado_model.dart';
import 'package:capama_app/models/reporte_usuario_model.dart';
import 'package:capama_app/models/usuario_model.dart';
import 'package:capama_app/services/bloc.dart';
import 'package:flutter/material.dart';
import 'package:postgresql2/postgresql.dart';
import 'package:provider/provider.dart';
import 'package:capama_app/utils/enviarEmail.dart';

class Conexion {
  String _uri =
      'postgres://vnbbycaoogxzuj:15230dde06eedf9f95609eddd6bdc4f3ed65f81174f7a7b29caf2c98b75068c9@ec2-3-232-148-66.compute-1.amazonaws.com:5432/d94d6j212q36rl?sslmode=require';
  List<Usuario> usuarios = new List();
  List<List<String>> listemp = new List();
  bool flagLogin = false;

  //stream

  //instancia para los correos
  EmailReset sendEmailUserEmployed = new EmailReset();
  //Consulta a todos los usuarios
  queryAllUsers() {
    connect(_uri).then((conn) {
      conn.query("select * from reportes_usuarios;").toList().then((rows) {
        for (var row in rows) {
          final List<String> temp = new List();
          temp.add(row[0].toString());
          temp.add(row[1]);
          temp.add(row[2]);
          temp.add(row[3]);
          temp.add(row[4]);
          temp.add(row[5]);
          temp.add(row[6]);
          temp.add(row[7]);
          temp.add(row[8]);
          print(temp);
          listemp.add(temp);
        }
        for (var value in listemp) {
          final usertemp = Usuario.fromQueryTo(value);
          usuarios.add(usertemp);
        }

        return usuarios;

        /*
      print(usuarios); 
      print(usuarios[0].nombre); para acceder al valor del arreglo
      print(usuarios[1].nombre);
    */
      });
    });
  }

/*
Consulta si existe el correo en la bd
retorna false si no existe
true si existe
para la tabla usuarios
 */
  Future<bool> queryEmailUser(String email) {
    return connect(_uri).then((conexion) {
      return conexion
          .query("select COUNT(*) from reportes_usuarios where email = @email",
              {'email': email})
          .toList()
          .then((resultado) {
            conexion.close();
            for (var dato in resultado) {
              if (dato[0] == 0) {
                print("correo no existe");
                return false;
              } else {
                print("Este correo ya esta registrado!");

                return true;
              }
            }
          });
    });
  }

  Future<bool> executeMateriales(String query)
  {

    return connect(_uri).then((conn) {
      return conn.execute("INSERT INTO reportes_materiales (material,cantidad,id_reporte_empleado_id) VALUES $query").then((value) => value==1?true:false);
    });
  }
  
  //Modifica el estado del empleado()
  Future<bool> executeEstadoEmpleado(String idEmpleado,String estado)
  {
    return connect(_uri).then((conn) {
      return conn.execute("UPDATE reportes_empleados SET disponibilidad = @estado WHERE id = @id",{
        "estado":estado,
        "id":idEmpleado
      }).then((value) => value==1?true:false);
    });
  }

  Future<String> queryIdReportEmpleado(String idReporteUser)
  {
    return connect(_uri).then((conn) {
      return conn.query("SELECT id from reportes_reportesempleado  where id_repoteusuario_id =@id ORDER BY id DESC",{"id":idReporteUser}).toList().then(
        (rows) {
          print("Consulta:${rows[0][0]} querytreporteEmpl");
          return rows[0][0].toString();
                  });
    });
  }
  
  //Consulta todos los correos existentes, exepto uno.
  //Permite saber si el correo que ingresa existe en la bd
Future<bool> queryEmailUserDistinct(String email, String emailQuery)
{
  bool flag = true;
  return connect(_uri).then(
    (conexion) {
      return conexion.query("SELECT email from reportes_usuarios WHERE email != @email",{
        "email":email
      }).toList().then((value) {
        value.forEach((element) {
          if(element[0] == emailQuery)
          {
            //Si el nuevo correo existe

            flag = false;
          }
        });
        //todo ok

        return flag;
      });
    });
}

 //Consulta todos los correos existentes, exepto uno.
  //Permite saber si el correo que ingresa existe en la bd
Future<bool> queryEmailEmployeeDistinct(String email, String emailQuery)
{
  bool flag = true;
  return connect(_uri).then(
    (conexion) {
      return conexion.query("SELECT email from reportes_empleados WHERE email != @email",{
        "email":email
      }).toList().then((value) {
        value.forEach((element) {
          if(element[0] == emailQuery)
          {
            //Si el nuevo correo existe

            flag = false;
          }
        });
        //todo ok

        return flag;
      });
    });
}

  Future<bool> queryEmailWorker(String email) {
    return connect(_uri).then((conexion) {
      return conexion
          .query("select COUNT(*) from reportes_empleados where email = @email",
              {'email': email})
          .toList()
          .then((resultado) {
            conexion.close();
            for (var dato in resultado) {
              if (dato[0] == 0) {
                print("correo no existe");
                return false;
              } else {
                print("Este correo ya esta registrado!");

                return true;
              }
            }
          });
    });
  }

  Future<bool> queryContrato(String contrato) {
    return connect(_uri).then((conexion) {
      return conexion
          .query(
              "select COUNT(*) from reportes_usuarios where Num_contrato = @contrato",
              {'contrato': contrato})
          .toList()
          .then((resultado) {
            conexion.close();
            for (var dato in resultado) {
              if (dato[0] == 0) {
                print("Contrato no existe");
                return false;
              } else {
                print("Contrato registrado");

                return true;
              }
            }
          });
    });
  }

//Consulta la existencia de un usuario
// true si existe, false si no.
//Se devuelve el arreglo usando provider
  Future<bool> queryLogin(String email, String password, BuildContext context) {
    return connect(_uri).then((conexion) {
      // no sé cómo funciona
      final usuarioData = Provider.of<UsuarioProvider>(context, listen: false);

      return conexion
          .query(
              "select * from reportes_usuarios where email = @email and contrasena = @pass",
              {
                'email': email,
                'pass': password
              }) //consultar en la bd si el email y la contraseña son correctos
          .toList() //transformar los resultados en una lista
          .then((resultados) {
            conexion.close(); //cerrar la conexión para evitar que se sature heroku

           
            if (resultados.length == 1) 
            {
              // si la longitud del resultado es 1, significa que la contraseña y el email son correctos
              Usuario usuarioact = new Usuario.fromQueryTo(resultados[
                  0]); //almacenar toda la info en el provider de usuario.
              // no sé cómo funciona
              usuarioData.usuario = usuarioact;
              return true;
            } else {
              return false;
            }
          });
    });
  }

  Future<bool> queryLoginWorker(
      String email, String password, BuildContext context) {
    return connect(_uri).then((conexion) {
      final UsuarioProvider worker =
          Provider.of<UsuarioProvider>(context, listen: false);
      return conexion
          .query(
              "select * from reportes_empleados where email = @email and contrasena = @pass",
              {
                'email': email,
                'pass': password
              }) //consultar en la bd si el email y la contraseña son correctos
          .toList() //transformar los resultados en una lista
          .then((resultados) {
            conexion.close();
            if (resultados.length == 1) {
              // si la longitud del resultado es 1, significa que la contraseña y el email son correctos
              Empleado empleado = new Empleado.fromJson(resultados[0]);
              //almacenar toda la info en el provider de usuario.
              // no sé cómo funciona
              worker.empleado = empleado;
              return true;
            } else {
              return false;
            }
          });
    });
  }
Future <bool> attendedReport(ReporteUsuario data, String fotografia,String descripcion)
{
  var time = DateTime.now();
  return connect(_uri).then((conn) 
  {
      print("ok woa insertar");
    return conn.execute('INSERT INTO reportes_reportesempleado (descripcion,estado,fecha_inicio,fecha_fin,foto,id_empleado_id,id_repoteUsuario_id,prioridad,tipo_anomalia,tipo_servicio,zona) VALUES(@descripcion,@estado,@fecha_inicio,@fecha_fin,@foto,@id_empleado_id,@id_repoteUsuario_id,@prioridad,@tipo_anomalia,@tipo_servicio,@zona)',
    {
      "descripcion":descripcion,
      "estado":"Atendido",
      "fecha_inicio":data.fecha,
      "fecha_fin":time.toUtc(),
      "foto":fotografia,
      "id_empleado_id":data.idempleado,
      "id_repoteUsuario_id":data.idReport,
      "prioridad":data.prioridad,
      "tipo_anomalia":data.anomalia,
      "tipo_servicio":data.servicio,
      "zona":data.zona
    }).then((value) => value >=1? true: false);
  });
}
//Inserta el usuario
  Future<bool> insertReportUser(ReporteUsuario data, String fotografia) {
    return connect(_uri).then((conn) {
      conn.execute(
          "INSERT INTO reportes_reportesusuario(calle,colonia,cp,descripcion,estado,fecha,folio_seguimiento,foto,geolocalizacion,id_usuario_id,num_exterior,num_interior,prioridad,tipo_anomalia,tipo_servicio,zona) VALUES(@calle,@colonia,@cp,@descripcion,@estado,@fecha,@folio_seguimiento,@foto,@geolocalizacion,@id_usuario_id,@num_exterior,@num_interior,@prioridad,@tipo_anomalia,@tipo_servicio,@zona)",
          {
            'calle': data.getCalle,
            'colonia': data.getColonia,
            'cp': data.getCp,
            'descripcion': data.getDescripcion,
            'estado': data.getEstado,
            'fecha': data.getFecha,
            'folio_seguimiento': data.getFolio,
            'foto': fotografia,
            'geolocalizacion': data.geolocalizacion,
            'id_usuario_id': data.getIdUser,
            'num_exterior': data.getNumeroExt,
            'num_interior': data.getNumeroInt,
            'prioridad': data.getPrioridad,
            'tipo_anomalia': data.getAnomalia,
            'tipo_servicio': data.getServicio,
            'zona': data.getZona
          });
    }).then((value) => true);
  }

  Future<bool> insertUser(Usuario usuario) {
    return connect(_uri).then((conexion) {
      return conexion.execute(
          "INSERT INTO reportes_usuarios(Nombre,Apellidos,Email,Contrasena,Num_contrato,Telefono,Colonia,Calle,Cp) VALUES(@Nombre,@Apellidos,@Email,@Contrasena,@Num_contrato,@Telefono,@Colonia,@Calle,@cp)",
          {
            "Nombre": usuario.nombre,
            "Apellidos": usuario.apellidos,
            "Email": usuario.correos,
            "Contrasena": usuario.contrasena,
            "Num_contrato": usuario.contrato,
            "Telefono": usuario.telefono,
            "Colonia": usuario.colonia,
            "Calle": usuario.calle,
            "cp": usuario.cp
          }).then((value) => value >= 1 ? true : false);
    });
  }

  Future<bool> updateReport(String estado, String idReporte) {
    return connect(_uri).then((conexion) {
      return conexion.execute(
          "UPDATE reportes_reportesusuario SET estado = @estado  WHERE id = @id",
          {'id': idReporte, 'estado': estado}).then((value) {
        conexion.close();
        if (value >= 1) {
          print("see");
          return true;
        } else {
          print("error we");
          return false;
        }
      });
    });
  }

//No implementado
  Future<bool> updateUserD(Usuario usuario) {
    return connect(_uri).then((conexion) {
      return conexion.execute(
          "UPDATE reportes_usuarios SET nombre = @Nombre, apellidos=@Apellidos,email = @Email,contrasena = @Contrasena,num_contrato = @Num_contrato,telefono = @Telefono,colonia = @Colonia,calle = @Calle,cp = @cp where id = @id",
          {
            "Nombre": usuario.nombre,
            "Apellidos": usuario.apellidos,
            "Email": usuario.correos,
            "Contrasena": usuario.contrasena,
            "Num_contrato": usuario.contrato,
            "Telefono": usuario.telefono,
            "Colonia": usuario.colonia,
            "Calle": usuario.calle,
            "cp": usuario.cp,
            "id":usuario.id
          }).then((value) => value == 1 ? true : false);
    });
  }

  Future<bool> updateEmployeeD(Empleado usuario) {
    return connect(_uri).then((conexion) {
      return conexion.execute(
          "UPDATE reportes_empleados SET nombre = @Nombre, apellidos=@Apellidos,email = @Email,contrasena = @Contrasena,telefono = @Telefono,colonia = @Colonia,calle = @Calle,cp = @cp where id = @id",
          {
            "Nombre": usuario.nombre,
            "Apellidos": usuario.apellidos,
            "Email": usuario.email,
            "Contrasena": usuario.contrasena,
            "Telefono": usuario.telefono,
            "Colonia": usuario.colonia,
            "Calle": usuario.calle,
            "cp": usuario.cp,
            "id":usuario.id
          }).then((value) => value >= 1 ? true : false);
    });
  }
  Future<bool> queryReportUser(String id) {
    return connect(_uri).then((conn) {
      conn
          .query(
              "SELECT * FROM reportes_reportesusuario where id_usuario_id = @id",
              {'id': id})
          .toList()
          .then((resultados) {
            for (var resultado in resultados) {
              DateTime ant = resultado[14];
              print(ant.toLocal());
            }
          });
    });
  }

//le quité los futures, porque no sabía cómo añadir los datos auna Future<List<String>>
  List<dynamic> queryRerportsUsers(String id) {
    List<dynamic> reportes = [];
    // aquí retornaba la función, por eso recibía null, por ello ahora mando la lista reportes.
    connect(_uri).then((conexion) {
      // hacer la consulta
      conexion
          .query(
              "SELECT * FROM reportes_reportesusuario where id_usuario_id = @id ORDER BY id DESC LIMIT 20 ",
              {'id': id})
          .toList()
          .then((resultados) {
            //cerrar la conexión
            conexion.close();
            for (var resultado in resultados) {
              // añadir los reportes a la lista
              reportes.add(resultado.toList());
            }
            // esperar los resultados
            Future.delayed(Duration(seconds: 2));
          });
    });
    return reportes;
  }

//mostrar el reporte asignado al empleado
  List<dynamic> queryRerportsEmploy(String id) {
    List<dynamic> reportes = [];
    // aquí retornaba la función, por eso recibía null, por ello ahora mando la lista reportes.
    connect(_uri).then((conexion) {
      // hacer la consulta
      conexion
          .query(
              "SELECT * FROM reportes_reportesusuario where id_empleado_id = @id and (estado = 'En proceso' or estado = 'Monitoreado')",
              {'id': id})
          .toList()
          .then((resultados) {
            //cerrar la conexión
            conexion.close();
            for (var resultado in resultados) {
              // añadir los reportes a la lista
              reportes.add(resultado.toList());
            }
            // esperar los resultados
            Future.delayed(Duration(seconds: 2));
          });
    });
    return reportes;
  }

  // extraer los reportes del empleado que ha atendido
  List<dynamic> queryRerportsEmployAttended(String id) {
    List<dynamic> reportes = [];
    // aquí retornaba la función, por eso recibía null, por ello ahora mando la lista reportes.
    connect(_uri).then((conexion) {
      // hacer la consulta
      conexion
          .query(
              "SELECT * from reportes_reportesusuario ru INNER JOIN reportes_reportesempleado re ON ru.id_empleado_id = re.id_empleado_id where re.id_empleado_id = @id and ru.estado = 'Atendido' ORDER BY re.id DESC LIMIT 20",
              {'id': id})
          .toList()
          .then((resultados) {
            //cerrar la conexión
            conexion.close();
            print(resultados);
            for (var resultado in resultados) {
              // añadir los reportes a la lista
              reportes.add(resultado.toList());
            }
            // esperar los resultados
            Future.delayed(Duration(seconds: 2));
          });
    });
    return reportes;
  }

//obtener los materiales utilizados
  List<dynamic> queryMaterials(int idReporte) {
    List<dynamic> materials = [];
    // aquí retornaba la función, por eso recibía null, por ello ahora mando la lista reportes.
    connect(_uri).then((conexion) {
      // hacer la consulta
      conexion
          .query(
              "SELECT * FROM reportes_materiales where id_reporte_empleado_id = @id",
              {'id': idReporte})
          .toList()
          .then((resultados) {
            //cerrar la conexión
            conexion.close();
            // print(resultados);
            for (var resultado in resultados) {
              // añadir los reportes a la lista
              materials.add(resultado.toList());
            }
            // esperar los resultados
            Future.delayed(Duration(seconds: 2));
          });
    });
    return materials;
  }

// verificar si el corro existe en la tabla de empleados o de usuarios
  Future<bool> queryEmailUserReset(String email, String numero) {
    bool existUserEmail = false;
    String asunto = 'Recuperación de contraseña';
    String mensaje = 'La contraseña de acceso a capamaApp es: ';

    String pass = "";
// buscar en los usuarios y EXTRAER LA CONTRASEÑA
    return connect(_uri).then((conexion) {
      return conexion
          .query(
              "select contrasena from reportes_usuarios where email = @email and num_contrato = @numero",
              {'email': email, 'numero': numero})
          .toList()
          .then((resultado) {
            conexion.close();
            // si hay resultados, obtener el pass,*sólo seleccioné el campo de la contraseña*
            if (resultado.length == 1) {
              pass = resultado[0][0];
              print('contra Usuario: $pass');
              sendEmailUserEmployed.sendMail(email, pass, asunto, mensaje);
              return true;
            } else {
              print('no hay usuario');
              return queryEmailEMployed(email, numero, asunto, mensaje);
            }
          });
    });
  }

  Future<bool> queryEmailEMployed(
      String email, String numero, String asunto, String mensaje) {
    String pass = "";
// buscar en los empleados y EXTRAER LA CONTRASEÑA
    return connect(_uri).then((conexion) {
      return conexion
          .query(
              "select contrasena from reportes_empleados where email = @email and num_empleado = @numero",
              {'email': email, 'numero': numero})
          .toList()
          .then((resultado) {
            conexion.close();
            if (resultado.length == 1) {
              pass = resultado[0][0];
              print('contra empleado: $pass');
              sendEmailUserEmployed.sendMail(email, pass, asunto, mensaje);
              return true;
            } else {
              print('no hay empleado');
              return false;
            }
          });
    });
  }

  void notifyUser(int id, String estado, String asunto, String mensaje) {
    String email = "";
// buscar en los usuarios y EXTRAER su corre o
    connect(_uri).then((conexion) {
      return conexion
          .query(
              "select email from reportes_usuarios where id = @id", {'id': id})
          .toList()
          .then((resultado) {
            conexion.close();
            if (resultado.length == 1) {
              email = resultado[0][0].toString();
              print('email usuario: $email');
              sendEmailUserEmployed.sendMailNotify(
                  email, estado, asunto, mensaje);
              return true;
            } else {
              print('no se encontró el email');
              return false;
            }
          });
    });
  }

  Future<bool> reportUserChange(int id) {
    return connect(_uri).then((conexion) {
      return conexion
          .query(
              "SELECT estado, id_empleado_id FROM reportes_reportesusuario where id = @id",
              {'id': id})
          .toList()
          .then((value) {
            conexion.close();
            print('estado: ${value[0][0]}');
            print('empleado: ${value[0][1]}');
            if ((value[0][0].toString() == 'Monitoreado' ||
                    value[0][0].toString() == 'En proceso') &&
                value[0][1] != null) {
              print("actualizar");
              return true;
            } else {
              print("poner sink []");
              return false;
            }
          });
    });
  }
}
