class ReporteUsuario {
  String nombre;
  String apellidos;
  String anomalia;
  String servicio;
  String folio;
  String foto;
  String prioridad;
  String latitud;
  String longitud;
  String colonia;
  String calle;
  String cp;
  String numeroInt;
  String numeroExt;
  int idUser;
  String descripcion;
  String zona;
  DateTime fecha;
  String estado;
  String idReport;
  String idempleado;

  String get getIdempleado => idempleado;

  set setIdempleado(String idempleado) => this.idempleado = idempleado;
  String get getIdReport => idReport;

  set setIdReport(String idReport) => this.idReport = idReport;

  String get getEstado => estado;

  set setEstado(String estado) => this.estado = estado;
  DateTime get getFecha => fecha;

  set setFecha(DateTime fecha) => this.fecha = fecha;

  String get getZona => zona;

  set setZona(String zona) => this.zona = zona;

  String get getDescripcion => descripcion;

  set setDescripcion(String descripcion) => this.descripcion = descripcion;

  String get getNombre => nombre;

  set setNombre(String nombre) => this.nombre = nombre;

  String get getApellidos => apellidos;

  set setApellidos(String apellidos) => this.apellidos = apellidos;

  String get getAnomalia => anomalia;

  set setAnomalia(String anomalia) => this.anomalia = anomalia;

  String get getServicio => servicio;

  set setServicio(String servicio) => this.servicio = servicio;

  String get getFolio => folio;

  set setFolio(String folio) => this.folio = folio;

  String get getFoto => foto;

  set setFoto(String foto) => this.foto = foto;

  String get getPrioridad => prioridad;

  set setPrioridad(String prioridad) => this.prioridad = prioridad;

  String get getLatitud => latitud;

  set setLatitud(String latitud) => this.latitud = latitud;

  String get getLongitud => longitud;

  set setLongitud(String longitud) => this.longitud = longitud;

  String get getColonia => colonia;

  set setColonia(String colonia) => this.colonia = colonia;

  String get getCalle => calle;

  set setCalle(String calle) => this.calle = calle;

  String get getCp => cp;

  set setCp(String cp) => this.cp = cp;

  get getNumeroInt => numeroInt;

  set setNumeroInt(String numeroInt) => this.numeroInt = numeroInt;

  String get getNumeroExt => numeroExt;

  set setNumeroExt(String numeroExt) => this.numeroExt = numeroExt;

  int get getIdUser => idUser;

  set setIdUser(int idUser) => this.idUser = idUser;

  get geolocalizacion {
    return "${this.longitud},${this.latitud}";
  }

  ReporteUsuario(
      {this.nombre,
      this.apellidos,
      this.anomalia,
      this.servicio,
      this.folio,
      this.foto,
      this.prioridad,
      this.latitud,
      this.longitud,
      this.colonia,
      this.calle,
      this.cp,
      this.numeroInt,
      this.numeroExt,
      this.idUser,
      this.idempleado});

  ReporteUsuario.fromMap(List dataMap) {
    nombre = dataMap[0].toString();
    apellidos = dataMap[1].toString();
    anomalia = dataMap[2].toString();
    servicio = dataMap[3].toString();
    folio = dataMap[4].toString();
    foto = dataMap[5].toString();
    prioridad = dataMap[6].toString();
    latitud = dataMap[7].toString();
    longitud = dataMap[8].toString();
    colonia = dataMap[9].toString();
    calle = dataMap[10].toString();
    cp = dataMap[11].toString();
    numeroInt = dataMap[12].toString();
    numeroExt = dataMap[13].toString();
    idUser = dataMap[14];
  }

  ReporteUsuario.fromEmployee(List dataMap) {
    idReport = dataMap[0].toString();
    zona = dataMap[1].toString();
    anomalia = dataMap[2].toString();
    servicio = dataMap[3].toString();
    folio = dataMap[4].toString();
    foto = dataMap[5].toString();
    prioridad = dataMap[6].toString();
    //Geolocalizacion
    colonia = dataMap[8].toString();
    calle = dataMap[9].toString();
    cp = dataMap[10].toString();
    numeroInt = dataMap[11].toString();
    numeroExt = dataMap[12].toString();
    descripcion = dataMap[13].toString();
    fecha = DateTime.parse(dataMap[14].toString());
    estado = dataMap[15].toString();
    idempleado = dataMap[16].toString();
    idUser = dataMap[17];
  }
}
