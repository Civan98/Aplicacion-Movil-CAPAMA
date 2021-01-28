import 'package:capama_app/services/colonias_services.dart';
import 'package:flutter/material.dart';

class CPSearch extends SearchDelegate
{
String colonia;
CPSearch({this.colonia});
String seleccion;

  @override
  List<Widget> buildActions(BuildContext context) 
  {
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
  Widget buildSuggestions(BuildContext context) 
  {
    return FutureBuilder(
      future: procesarCP(),
      builder: (BuildContext context, AsyncSnapshot snapshot)
      {
        if(snapshot.hasError)
        {
          return Center(child: Text("Ocurrió un error"));
        }

        if(snapshot.connectionState == ConnectionState.done)
        {
          List mydata = snapshot.data;
          return ListView.builder
          (itemCount: mydata.length,
          itemBuilder: (BuildContext context, int index)
          {
            return Card(
                child: ListTile(
                title: Text(mydata[index]),
                trailing: Icon(Icons.arrow_forward),
              onTap: ()
              {
              seleccion = mydata[index];
              close(context,seleccion);

            },
                
              ),
            );
          },
          );
        }

        else
        {
          return Center(child:CircularProgressIndicator());
        }
      },
    );
  }
  Future procesarCP() 
  {
      final colonias = ColoniasProvider().getCP(colonia);
      return colonias;

  }
}