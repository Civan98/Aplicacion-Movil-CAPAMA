import 'package:capama_app/services/colonias_services.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class AddressSearch extends SearchDelegate 
{
List<String> colonias = ColoniasProvider().localColonias();
String seleccion;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Borrar',
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Volver',
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final listaSugerida = (query.isEmpty)?
                          colonias.take(10).toList():
                          colonias.where((cl) => removeDiacritics(cl).toLowerCase().startsWith(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: listaSugerida.length,

      itemBuilder: (context,int index)
      {
        return Card(
          child: ListTile(
            trailing: Icon(Icons.arrow_forward),
            title: Text(listaSugerida[index].toString()),
            onTap: (){
              seleccion = listaSugerida[index];
              close(context,seleccion);

            },
          ),
        );
      }
      
      );
  }
}