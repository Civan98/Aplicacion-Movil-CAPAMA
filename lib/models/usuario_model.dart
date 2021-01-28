class Usuario
{
  String id;
  String nombre;
  String apellidos;
  String correos;
  String contrasena;
  String contrato;
  String telefono;
  String colonia;
  String calle;
  String cp;
  
 String get getId => id;

 set setId(String id) => this.id = id;

 String get getNombre => nombre;

 set setNombre(String nombre) => this.nombre = nombre;

 String get getApellidos => apellidos;

 set setApellidos(String apellidos) => this.apellidos = apellidos;

 String get getCorreos => correos;

 set setCorreos(String correos) => this.correos = correos;

 String get getContrasena => contrasena;

 set setContrasena(String contrasena) => this.contrasena = contrasena;

 String get getContrato => contrato;

 set setContrato(String contrato) => this.contrato = contrato;

 String get getTelefono => telefono;

 set setTelefono(String telefono) => this.telefono = telefono;

 String get getColonia => colonia;

 set setColonia(String colonia) => this.colonia = colonia;

 String get getCalle => calle;

 set setCalle(String calle) => this.calle = calle;

 String get getCp => cp;

 set setCp(String cp) => this.cp = cp;
  Usuario({this.id,this.nombre,this.apellidos,this.correos,this.contrasena,this.contrato,this.telefono,this.colonia,this.calle,this.cp});

Usuario.fromQueryTo (query)
{
  id            =   query[0].toString();
   nombre       =   query[1].toString();
   apellidos    =   query[2].toString();
   correos      =   query[3].toString();
   contrasena   =   query[4].toString();
   contrato     =   query[5].toString();
   telefono     =   query[6].toString();
   colonia      =   query[7].toString();
   calle        =   query[8].toString();
   cp           =   query[9].toString();
}

}