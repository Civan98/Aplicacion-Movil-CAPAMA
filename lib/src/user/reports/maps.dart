import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class FullScreenMap extends StatefulWidget {
  FullScreenMap({Key key}) : super(key: key);

  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
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
    final _screen = MediaQuery.of(context).size;
    String reporte = ModalRoute.of(context).settings.arguments;
    print(reporte);
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicación del Reporte"),
        centerTitle: true,
      ),
      body: mapa(reporte, _screen),
    );
  }

  Widget mapa(String reporte, _screenSize) {
    var ubicacion = reporte;
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
            compassEnabled: true,
            onMapCreated: _onMapCreated,
            //donde iran las coordenadas iniciales donde se carga el mapa
            initialCameraPosition:
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
}
