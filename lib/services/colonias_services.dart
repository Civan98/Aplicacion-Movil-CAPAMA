import 'dart:convert';
import 'package:http/http.dart' as http;
//Permite obtener las colonias existentes en Acapulco.
//Hay dos métodos, la primera obtiene los datos desde una API
//el segundo es un arreglo local de las colonias.
//La api devuelve un formato utf 8 asi que el arreglo es mejor.

class ColoniasProvider
{

  String _api = "api-sepomex.hckdrk.mx";
  String _query = "/query/get_colonia_por_municipio/Acapulco de juarez";
  String _queryCP = "/query/search_cp_advanced/Guerrero";
  String _municipio = "Acapulco de juarez";



 Future getCP (String colonia) async{

    final url =  Uri.https(_api,_queryCP,{
      "limit":"10",
      "municipio":_municipio,
      "colonia": colonia,
    });
    final resp = await http.get(url);
    print(url);
    final decodedData = json.decode(resp.body);
    print("CP devueltos: ${decodedData["response"]["cp"]}");
    return decodedData["response"]["cp"];
 }

  Future getColonias () async{

    final url =  Uri.https(_api,_query);
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    return decodedData["response"]["colonia"];
 }

  List<String> localColonias()
 {
    
   List<String> coloniasList =
   [
     "Acapulco de Juárez Centro",
            "Del Hueso",
            "Del Panteón",
            "El Capire",
            "Pozo de la Nación",
            "Hornos Insurgentes",
            "Progreso",
            "13 de Junio",
            "Hornos",
            "Real de Acapulco",
            "Cuerería",
            "Hospital",
            "La Lima",
            "Las Crucitas",
            "Petaquillas",
            "El Mesón",
            "Del Teconche",
            "La Candelaria",
            "La Guinea",
            "La Pinzona",
            "La Pocita",
            "La Poza",
            "Los Tepetates",
            "Cumbres INFONAVIT",
            "Farallón INFONAVIT",
            "Flamingos INFONAVIT",
            "Playa Roqueta",
            "Tambuco",
            "Club Residencial las Américas",
            "Bodega",
            "Las Playas",
            "Península de las Playas",
            "Vicente Guerrero",
            "Ángel Aguirre",
            "Corregidora",
            "Ignacio Manuel Altamirano",
            "Jardín Azteca",
            "Nueva Jerusalén",
            "20 de Abril",
            "El Paraíso",
            "Reforma Agraria",
            "Roca de Oro",
            "Miramar",
            "Pedregoso",
            "Ampliación San Isidro",
            "Valle de las Flores",
            "Brisas del Mar",
            "Tepeyac",
            "Los Mangos",
            "Costa Brava Terranova",
            "Jardín Mangos",
            "Excampo de Tiro",
            "Jardín Palmas",
            "Las Joyas",
            "SEMARNAP",
            "Puesta del Sol",
            "Balcones al Mar",
            "Generación 2000",
            "La Nueva Era",
            "Ricardo Morlett Sutter",
            "Universitaria",
            "Venustiano Carranza",
            "Nueva Era",
            "Rubén Jaramillo",
            "Luis Donaldo Colosio",
            "Marbella",
            "Mozimba",
            "Vicente Lombardo Toledano",
            "Antorcha Revolucionaria",
            "Mozimba 1a Secc",
            "José López Portillo INFONAVIT",
            "Mozimba Secc Jardín",
            "Adolfo López Mateos",
            "Potrerillo",
            "Mozimba FOVISSSTE",
            "La Mira",
            "Los Naranjos",
            "Municipal",
            "Taxco",
            "Los Naranjitos",
            "Las Marañonas",
            "Leonardo Rodriguez Alcaine",
            "Vicente Guerrero FOVISSSTE",
            "Independencia",
            "Palma Sola",
            "Ampliación Palma Sola",
            "Constituyentes",
            "Santa Cecilia",
            "Guadalupe Victoria",
            "María de La O",
            "Morelos",
            "Santa Cruz",
            "Olímpica",
            "Silvestre Castro",
            "Juan R Escudero",
            "Ampliación Silvestre Castro",
            "Solidaridad",
            "Alta Cuauhtémoc",
            "Bellavista",
            "Cuauhtémoc",
            "Ampliación Cuauhtémoc",
            "El Mirador",
            "Ampliación Bellavista",
            "Vista Alegre",
            "Emiliano Zapata",
            "La Florida INFONAVIT",
            "La Florida",
            "Hogar Moderno",
            "Miguel Alemán",
            "Aguas Blancas",
            "Carabalí Centro",
            "La Fabrica",
            "Palmar de Carabalí",
            "Cuauhtémoc INFONAVIT",
            "Frontera",
            "La Laja",
            "La Laja Parte Alta",
            "Alta Progreso INFONAVIT",
            "Altamira",
            "Ampliación Altamira Norte",
            "Burócrata",
            "Francisco Villa",
            "Margarita de Gortari",
            "6 de Enero",
            "Alta Progreso",
            "Panorámica",
            "Revolución del Sur",
            "Buenavista",
            "Guerrero Es Primero",
            "Periodistas",
            "Unidad Obrera",
            "La Providencia",
            "La Quebradora",
            "Loma Bonita",
            "Vista Hermosa",
            "Alianza Popular",
            "Barranca de la Laja",
            "Bocamar",
            "Las Américas",
            "Las Anclas",
            "Militar",
            "El Roble",
            "Marroquín",
            "Santa Elena",
            "Del Valle",
            "Garita de Juárez",
            "Loma Hermosa",
            "Pacifico",
            "20 de Noviembre",
            "Gustavo Diaz Ordaz",
            "Magallanes",
            "Rodrigo de Triana",
            "Las Cumbres",
            "Lomas de Magallanes",
            "Cumbres Diana",
            "Magisterio Guerrerense",
            "Bosques de la Cañada",
            "Cumbres de Figueroa",
            "Pablo Galeana",
            "Cañada de los Amates",
            "Club Deportivo",
            "Condesa",
            "Chinameca",
            "Farallón",
            "INFONAVIT Centro Acapulco",
            "Jardín de los Amates",
            "Villas Condesa",
            "El Palmar",
            "Ampliación Emiliano Zapata",
            "Graciano Sanchez",
            "Leona Vicario",
            "Ricardo Flores Magón",
            "Tierra y Libertad",
            "24 de Octubre",
            "Caudillo del Sur",
            "Fidel Velázquez Sanchez",
            "México",
            "Ampliación Lomas Verdes",
            "C N C",
            "Yoloxochil",
            "Sinai",
            "Ampliación Sinai",
            "Genaro Vázquez",
            "Del PRI",
            "Electricistas",
            "Roberto Esperon",
            "Victoria Rosales",
            "Villa los Mangos",
            "Alejo Peralta",
            "16 de Noviembre",
            "Rubén Figueroa",
            "La Frontera",
            "Democrática",
            "Ampliación Arroyo Seco",
            "Batalla Cardenista",
            "Agrícola",
            "La Esmeralda",
            "La Mica",
            "Emperador Moctezuma",
            "Nopalitos",
            "Villa Sol",
            "El Porvenir",
            "La Venta",
            "SEDESOL Dos",
            "SEDESOL Uno",
            "El Tanque",
            "Valle del Palmar II",
            "Placido Domingo Sección A",
            "Paraíso Palmar III",
            "Betania",
            "Tamarindos",
            "Valle del Palmar I",
            "Ampliación la Mica",
            "Paso Limonero",
            "Nueva Generación",
            "Villas Real Hacienda",
            "Barrio Nuevo",
            "Ecologista",
            "Fidel Velázquez Sect 1",
            "Fuentes del Maurel II",
            "Renacimiento",
            "Arroyo Seco",
            "Nuevo Capire",
            "Primero de Mayo",
            "Coheteros",
            "Nueva Luz",
            "Villa Guerrero",
            "La Cima",
            "Benito Juárez",
            "Lázaro Cárdenas",
            "Parotas",
            "Ampliación Miguel Hidalgo",
            "Ampliación Niños Héroes",
            "Amin Zarur Menez",
            "Bascula",
            "Ampliación las Parotas",
            "Ampliación Miguel de La Madrid",
            "Niños Héroes",
            "Obrera",
            "Ampliación Lázaro Cárdenas",
            "CNOP",
            "2 de Febrero",
            "Jacarandas",
            "Industrial",
            "Las Torres",
            "Leyes de Reforma",
            "Narciso Mendoza",
            "Postal",
            "Tecnológica",
            "San Miguel",
            "Arboledas",
            "Unidos Por Guerrero",
            "José María Izazaga",
            "San Agustin",
            "Villa de las Flores",
            "José López Portillo",
            "Club Campestre",
            "Coral",
            "Emilio M Gonzalez",
            "Fuentes del Maurel I",
            "Huertas de Santa Elena",
            "Las Cruces",
            "Los Limoncitos",
            "Luz y Fuerza",
            "Libertadores",
            "Corales",
            "Loma Larga",
            "Villa Tulipanes",
            "Cereso I",
            "Ampliación José López Portillo",
            "Ampliación Simón Bolívar",
            "Simón Bolívar",
            "Villa Madero",
            "Ángel Aguirre Rivero",
            "Francisco Ruiz Massieu",
            "José María Pino Suárez",
            "Movimiento Territorial",
            "Nicolás Bravo",
            "Paraíso",
            "15 de Septiembre",
            "Revolución de Octubre",
            "Nicolás Bravo Junto A López Portillo",
            "Ampliación el Paraíso",
            "Miguel Terrazas",
            "La Libertad",
            "Ampliación la Libertad",
            "Los Lirios",
            "Ampliación los Lirios",
            "Amadeo Vidales",
            "Canuto Nogueda",
            "5 de Mayo",
            "Del Rastro",
            "Los Manantiales",
            "Ruffo Figueroa",
            "Héroes de Guerrero",
            "La Sabana",
            "Los Dragos",
            "Mártir de Cuilapan",
            "Melchor Ocampo",
            "La Maquina",
            "Ampliación la Maquina",
            "Rastro Viejo",
            "Salinas de Gortari",
            "El Coloso INFONAVIT",
            "Potrero de La Mora",
            "Apolonio Castillo",
            "Piedra Azul",
            "Piedra Roja",
            "Alta Loma la Esperanza",
            "La Esperanza",
            "La Navidad",
            "La Parota",
            "Milenia",
            "Nuevo Cayaco",
            "Navidad de Llano Largo",
            "Cumbres Llano Largo",
            "Lomas de Costa Azul",
            "Balcones de Costa Azul",
            "Hermenegildo Galeana",
            "Praderas de Guadalupe",
            "Reforma de Costa Azul",
            "Praderas de Costa Azul",
            "Costa Azul",
            "23 de Noviembre",
            "Centro de Convenciones",
            "Icacos",
            "Nuevo Centro de Población",
            "Alta Icacos",
            "PEMEX",
            "Brisamar",
            "Joyas de Brisamar",
            "Icacos Prolongación",
            "Club Residencial las Brisas",
            "Brisas Diamante",
            "Hotel las Brisas",
            "Base Naval Icacos",
            "Lomas del Marqués",
            "Pichilingue",
            "Playa Guitarrón",
            "Brisas del Marqués",
            "El Glomar",
            "Las Brisas 1",
            "Las Brisas 2",
            "Marina Brisas",
            "Alborada Cardenista",
            "Ciudad Luis Donaldo Colosio",
            "Granjas del Marqués",
            "Jardín Princesas I",
            "Jardín Princesas II",
            "La Chaparrita",
            "Olinalá Princess",
            "Parque Ecológico de Viveristas",
            "Puerto Marqués",
            "La Princesa",
            "Princess del Marqués Secc I",
            "Rinconada del Mar",
            "Villas del Paraíso Secc II",
            "Villas Diamante I",
            "Villas Diamante II",
            "Los Arcos",
            "Alfredo V Bonfil",
            "3 Vidas",
            "Cuquita Massieu",
            "El Podrido",
            "Plan de los Amates",
            "Rubén Robles Catalán",
            "2 Soles",
            "Puente del Mar",
            "Nuevo Puerto Marqués",
            "Club Playa Mar",
            "Villas de Golf Diamante",
            "Villas Princess I",
            "Villas Princess II",
            "Copacabana",
            "Princess del Marqués II",
            "Playa Diamante",
            "Real Diamante",
            "3 de Abril",
            "Villas Xcaret",
            "Altos de Miramar",
            "Altos del Marqués",
            "La Lajita",
            "Vista Brisa",
            "19 de Noviembre",
            "La Guadalupana",
            "Villas Paraíso Secc I",
            "Acapulco (Gral. Juan N. Álvarez)",
            "Pie de La Cuesta",
            "Barrio Nuevo de los Muertos",
            "El Quemado",
            "El Veladero (Veladero Morelos)",
            "Los Órganos San Agustín",
            "Carabalí",
            "El Salto",
            "Las Plazuelas",
            "El Metlapil",
            "Tuncingo",
            "Cayaco",
            "Joyas del Marques",
            "La Marquesa",
            "Misión del Mar",
            "La Zanja O La Poza",
            "Llano Largo",
            "Costa Dorada",
            "Tres Palos",
            "El Zapote",
            "Lomas del Aire",
            "Los Órganos de Juan R. Escudero",
            "Las Tortolitas",
            "Xaltianguis",
            "Xolapa",
            "Lagunillas",
            "Las Flores",
            "Cervantes Delgado",
            "Cantarranas",
            "Las Primaveras",
            "Los Mangos (El Quemado)",
            "Las Pilitas",
            "Retén",
            "Kilómetro 21",
            "Kilómetro 22",
            "Pueblo Madero",
            "Kilómetro 48",
            "Las Marías",
            "Kilómetro 45",
            "Piedra Imán",
            "Kilómetro 30",
            "La Calera",
            "El Pelillo",
            "San Antonio",
            "Tasajeras",
            "Texca",
            "Altos del Camarón",
            "Dos Arroyos",
            "Las Sabanillas",
            "Ejido Nuevo",
            "Kilómetro 40",
            "Kilómetro 42",
            "La Sierrita",
            "Lomas de San Juan",
            "Agua Zarca de la Peña",
            "Amatepec",
            "Huajintepec",
            "Pochotlaxco",
            "La Garrapata",
            "Las Parotas",
            "San José Cacahuatepec",
            "Lomas de Chapultepec",
            "Cacahuate",
            "El Bejuco",
            "El Campanario",
            "Huamuchitos",
            "La Concepción",
            "10 de Abril",
            "Cerro de Piedra",
            "El Arenal",
            "Nicolás Bravo (La Zanja del Poniente)",
            "San Pedro Cacahuatepec (Vereda de Amatillo)",
            "San Pedro de las Playas",
            "Vicente Guerrero 200",
            "San Isidro",
            "Aguas Calientes",
            "Apalani",
            "Las Cruces de Cacahuatepec",
            "El Carrizo",
            "El Rincón",
            "Amatillo",
            "Barra Vieja",
            "La Estación",
            "Laguna del Quemado",
            "Oaxaquillas",
            "Salsipuedes",
            "San Andrés Playa Encantada",
            "Apanhuac",
            "Cacahuatepec",
            "El Cantón",
            "Parotillas"
   ];
   
   return coloniasList;
 }

}

class CPs
{
  List<CP> listado = new List();

  CPs.fromArray(List<String> arreglo)
  {
    if (arreglo == null) return;
      arreglo.forEach((dato) {
        final cp = CP.fromjson(dato);
        listado.add(cp);
       });
  }

}
class CP
{
  String cp;

  CP({this.cp});

  CP.fromjson(String data)
  {
    cp = data;
  }
}