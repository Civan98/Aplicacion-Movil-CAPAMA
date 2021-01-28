class Empleado
{
  String id;
  String nombre;
  String apellidos;
  String email;
  String contrasena;
  String telefono;
  String cargo;
  String numEmpleado;
  String colonia;
  String calle;
  String cp;
  String zona;
  String disponibilidad;

 String get getId => id;

 set setId(String id) => this.id = id;

 String get getNombre => nombre;

 set setNombre(String nombre) => this.nombre = nombre;

 String get getApellidos => apellidos;

 set setApellidos(String apellidos) => this.apellidos = apellidos;

 String get getEmail => email;

 set setEmail(String email) => this.email = email;

 String get getContrasena => contrasena;

 set setContrasena(String contrasena) => this.contrasena = contrasena;

 String get getTelefono => telefono;

 set setTelefono(String telefono) => this.telefono = telefono;

 String get getCargo => cargo;

 set setCargo(String cargo) => this.cargo = cargo;

 String get getNumEmpleado => numEmpleado;

 set setNumEmpleado(String numEmpleado) => this.numEmpleado = numEmpleado;

 String get getColonia => colonia;

 set setColonia(String colonia) => this.colonia = colonia;

 String get getCalle => calle;

 set setCalle(String calle) => this.calle = calle;

 String get getCp => cp;

 set setCp(String cp) => this.cp = cp;

 String get getZona => zona;

 set setZona(String zona) => this.zona = zona;

 String get getDisponibilidad => disponibilidad;

 set setDisponibilidad(String disponibilidad) => this.disponibilidad = disponibilidad;

  Empleado({this.id,this.nombre,this.apellidos,this.email,this.contrasena,this.telefono,this.cargo,this.numEmpleado,this.colonia,this.calle,this.cp,this.zona,this.disponibilidad});
Empleado.fromJson(query)
{
   id             =  query[0].toString();
   nombre         =  query[1].toString();
   apellidos      =  query[2].toString();
   email          =  query[3].toString();
   contrasena     =  query[4].toString();
   telefono       =  query[5].toString();
   cargo          =  query[6].toString();
   numEmpleado    =  query[7].toString();
   colonia        =  query[8].toString();
   calle          =  query[9].toString();
   cp             =  query[10].toString();
   zona           =  query[11].toString();
   disponibilidad =  query[12].toString();
}
}