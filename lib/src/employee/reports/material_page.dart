import 'package:flutter/material.dart';

class MaterialesPage extends StatefulWidget {
  @override
  _MaterialesPageState createState() => _MaterialesPageState();
}

class _MaterialesPageState extends State<MaterialesPage> {
  TextEditingController _materialController = new TextEditingController();
  TextEditingController _cantidadController = new TextEditingController();
  String cantidad;
  final _keyForm =  GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar materiales"),
      ),
      body: Form(
        key:_keyForm,
        child: ListView(
          padding: EdgeInsets.all(10.0),
          children: [
          _material(context),
          _cantidad(context),
          addMaterialesx(context),
          ],
        ),
      ),
    );
  }

   Widget _material(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Material:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _materialController,
            keyboardType: TextInputType.streetAddress,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "ej. codo de pcv:",
              suffixIcon: Icon(Icons.location_city),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }
            return null;
          }
          ),
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }
Widget _cantidad(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Cantidad:",
            style: Theme.of(context).textTheme.headline1,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _cantidadController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              hintText: "piezas,metros,litros,etc.",
              suffixIcon: Icon(Icons.phone_outlined),
              hintStyle: TextStyle(
                  fontFamily: "MPLUSRounded1c", color: Colors.black38),
            ),
           validator: (value)
          {
            if(value.isEmpty)
            {
              return "Este campo es obligatorio.";
            }

            return null;
          }
          ,
          onChanged: (value)
          {
            cantidad = value;
            print(cantidad);
          },
          ),
        
          SizedBox(
            height: 12.0,
          ),
        ],
      ),
    );
  }

Widget addMaterialesx(BuildContext context) 
  {


    final _screenSize = MediaQuery.of(context).size;
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: _screenSize.width * 0.01,
            vertical: _screenSize.height * 0.024),
        child: Text(
          "Agregar",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      color: Colors.blue,
      onPressed: () 
      {
            
    final  Map materiales = 
    {
    "Materiales":_materialController.text,
    "Cantidad":cantidad,
    };

        if(_keyForm.currentState.validate())
        {
            Navigator.pop(context,materiales);
        }
      },
    );
  }

}