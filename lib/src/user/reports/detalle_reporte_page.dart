import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class DetallesPage extends StatefulWidget {
  @override
  _DetallesPageState createState() => _DetallesPageState();
}

class _DetallesPageState extends State<DetallesPage> {
  //instancia de mapbox
  MapboxMapController mapController;
  //es el encardo de conectar a la API y crear un controlador para el mapa instanciado
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

//obtener la imagen del marcador
  void _onStyleLoaded() {
    addImageFromUrl("networkImage",
        "https://res.cloudinary.com/dysntklpm/image/upload/c_scale,w_133/v1608706119/marcador_qbyyde.png");
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await http.get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    List<dynamic> reporte = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.blue,
      body: CustomScrollView(
        slivers: [
          crearAppBar(reporte),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(height: _screenSize.height * 0.03),
            infoCardReporte(context, reporte),
            SizedBox(height: _screenSize.height * 0.03),
          ])),
        ],
      ),
    );
  }

  Widget mapa(List reporte, _screenSize) {
    var ubicacion = reporte[7];
    var coordenadas = ubicacion.split(",");
    /* se obtiene las coordenadas del reporte y se aplica un split para dividirlas
      se tuvo que hacer el parseo porque el metodo solo acepta Doubles
    */
    var latitud = double.parse(coordenadas[1]);
    var longitud = double.parse(coordenadas[0]);

    return Column(
      //mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: _screenSize.height * 0.02),
          margin: EdgeInsets.symmetric(horizontal: _screenSize.width * 0.05),
          height: _screenSize.height *
              0.72, // debe llevar esto, si no se desborda el mapa
          child: MapboxMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: //donde iran las coordenadas iniciales donde se carga el mapa
                CameraPosition(target: LatLng(latitud, longitud), zoom: 16),
          ),
        ),
        Row(
            //PAra crear los botones de Zoom
            //Zoom In
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(Icons.zoom_in),
                  color: Colors.black,
                  onPressed: () {
                    mapController.animateCamera(CameraUpdate.zoomIn());
                  },
                ),
              ),
              //Boton Para añadir el marcador exacto del reporte en el mapa
              /*Se tuvo que crear un boton debido a que generaba un 
              error que se cargaran al mismo tiempo las coordenadas del mapa y las coordenadar del marcador
              */
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(Icons.add_location_alt_rounded),
                  color: Colors.black,
                  onPressed: () {
                    mapController.addSymbol(SymbolOptions(
                      geometry: LatLng(latitud, longitud),
                      iconSize: 1,
                      iconImage: 'networkImage',
                    ));
                    //textField: 'Aqui we'));
                  },
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: Icon(Icons.zoom_out),
                  color: Colors.black,
                  onPressed: () {
                    mapController.animateCamera(CameraUpdate.zoomOut());
                  },
                ),
              ),
            ]),
        SizedBox(height: _screenSize.height * 0.03),
      ],
    );
  }

  Widget crearAppBar(List reporte) {
    return SliverAppBar(
      backgroundColor: Colors.blue,
      elevation: 2.0,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text("Detalles del reporte"),
        centerTitle: true,
        background: FadeInImage(
          image: NetworkImage(reporte[5].toString()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  infoCardReporte(BuildContext context, List reporte) {
    final _screenSize = MediaQuery.of(context).size;
    DateTime fecha = reporte[14];
    fecha = fecha.toLocal();
    return Container(
      padding: EdgeInsets.symmetric(vertical: _screenSize.height * 0.02),
      margin: EdgeInsets.symmetric(horizontal: _screenSize.width * 0.05),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: Card(
              child: ListTile(
                title: Text("Folio de seguimiento:"),
                subtitle: Text("${reporte[4]}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Tipo de servicio:"),
                subtitle: Text("${reporte[3]}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Tipo de anomalía:"),
                subtitle: Text("${reporte[2]}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Zona:"),
                subtitle: Text("${reporte[1]}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Colonia:"),
                subtitle: Text("${reporte[8]}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Calle:"),
                subtitle: Text("${reporte[9]}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Código Postal:"),
                subtitle: Text("${reporte[10]}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Número interior y exterior:"),
                subtitle: Text(
                    "Número interior: ${reporte[11]}   Número exterior: ${reporte[12]}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Descripción:"),
                subtitle: Text("${reporte[13]}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Fecha del reporte:"),
                subtitle: Text("${fecha.year}/${fecha.month}/${fecha.day}"),
              ),
            )),
            Container(
                child: Card(
              child: ListTile(
                title: Text("Estado del reporte:"),
                subtitle: Text("${reporte[15]}"),
              ),
            )),
            Container(
              child: Card(
                  child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "mapa",
                            arguments: reporte[7]);
                      },
                      child: Text("Ver en el mapa"))),
            ),
          ],
        ),
      ),
    );
  }
}
